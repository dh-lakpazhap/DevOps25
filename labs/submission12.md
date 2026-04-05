# Lab 12 — WebAssembly Containers vs Traditional Containers

> **Goal:** Build a Go web application and compare WebAssembly (WASM) containers with traditional Docker containers using the **same source code** compiled to different targets.  
### Task 1 — Create the Moscow Time Application

**Traditional Server Mode**
![alt text](image.png)

**CLI Mode**
![alt text](image-1.png)

**Confirmation that you're working directly in labs/lab12/ directory**
![alt text](image-3.png)
![alt text](image-2.png)

- Traditional Server Mode (net/http): Когда мы запускаем код просто через go run или в обычном Docker, программа проверяет переменную окружения MODE. Если она не равна once, запускается стандартный бесконечный цикл http.ListenAndServe, который слушает порт :8080.

- CLI Mode (MODE=once): Если мы передаем переменную MODE=once, программа не запускает сервер. Она просто один раз вычисляет время в Москве, выводит его в консоль в формате JSON и тут же завершает работу.

- WAGI Mode (Spin Cloud): Для работы в облаке Spin программа использует функцию isWagi(). Она ищет специфические переменные (например, REQUEST_METHOD), которые Spin передает при каждом входящем запросе. В этом режиме программа не "слушает" порт сама — она просто печатает HTTP-заголовок и тело ответа в стандартный поток вывода (STDOUT), а Spin подхватывает это и отправляет пользователю.

### Task 2 — Build Traditional Docker Container

- Binary size from `ls -lh moscow-time-traditional` is 4.5M
- Image size from `docker images` is 4.7MB and Image size from `docker image inspect` is 4.48047 MB
- Average startup time across 5 CLI mode runs is 0.58 seconds
- Memory usage from `docker stats` (MEM USAGE column) is 1.195MiB
![alt text](image-4.png)
![alt text](image-5.png)

### Task 3 — Build WASM Container (ctr-based) 

In `labs/submission12.md`, document:
- TinyGo version 0.39.0 used 
- WASM binary size (from `ls -lh main.wasm`) is 2.4M
- WASI image size (from `ctr images ls`) is 819.9 KiB
- Average startup time from the `ctr run` benchmark loop (CLI mode) is  0.2560 seconds

- Explanation of why server mode doesn't work under `ctr` (WASI Preview1 lacks socket support)

Используемый стандарт WASI Preview1 не имеет системных вызовов для работы с сетевыми сокетами (TCP/IP). Поэтому приложение на Go не может открыть порт 8080 и «слушать» входящие запросы в этой среде.

- Note that server mode **can** be demonstrated via Spin using the same `main.wasm`

Тот же бинарный файл `main.wasm` успешно работает как сервер в среде Fermyon Spin. Это доказывает, что ограничение связано с рантаймом containerd, а не с кодом приложения. Spin выступает внешним обработчиком трафика для модуля.

- Memory usage reporting (likely "N/A" with explanation)

Стандартные инструменты мониторинга (вроде `docker stats`) не могут корректно замерить потребление ресурсов WASM-процесса, так как он запускается внутри легковесного шима (`shim`), а не как отдельный изолированный процесс ОС с cgroups.

Оба билда используют один и тот же исходный файл main.go
![alt text](image-6.png)

Успешный запуск WASM-контейнера через ctr с использованием рантайма wasmtime
![alt text](image-7.png)

### Task 4 — Comparison Summary

| Metric | Traditional Docker | WASM (ctr + wasmtime) | Difference |
| :--- | :--- | :--- | :--- |
| **Binary Size** | 4.5 MB | 2.4 MB | ~1.9x smaller |
| **Image Size** | 4.7 MB | 819.9 KiB | **~6x smaller** |
| **Startup Time (Avg)** | 0.58s | 0.256s | **~2.2x faster** |
| **Memory Usage** | 1.19 MiB | N/A (Ultra-low) | — |

### **Final Conclusions**
1.  **Efficiency:** WASM-образ оказался почти в 6 раз меньше Docker-образа, что критически важно для экономии места и скорости передачи данных.
2.  **Performance:** Время "холодного старта" у WASM более чем в 2 раза быстрее, что делает его идеальным для Edge-вычислений.
3.  **Portability:** Технология позволяет упаковывать один и тот же код в разные форматы (OCI, WASM), обеспечивая гибкость деплоя.
