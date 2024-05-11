local ffi = require("ffi")

-- ヾ(＾∇＾) Определение структур и функций из библиотеки Windows API
ffi.cdef[[
typedef unsigned long DWORD;
typedef void* HANDLE;
typedef struct _RECT {
    long left;
    long top;
    long right;
    long bottom;
} RECT;

HANDLE GetForegroundWindow(); -- ＼(＾▽＾)／ Получить дескриптор текущего активного окна
DWORD GetWindowThreadProcessId(HANDLE hWnd, DWORD* lpdwProcessId); -- ＼(＾▽＾)／ Получить идентификатор процесса по дескриптору окна
HANDLE OpenProcess(DWORD dwDesiredAccess, int bInheritHandle, DWORD dwProcessId); -- ＼(＾▽＾)／ Открыть дескриптор процесса
int ReadProcessMemory(HANDLE hProcess, const void* lpBaseAddress, void* lpBuffer, size_t nSize, size_t* lpNumberOfBytesRead); -- ＼(＾▽＾)／ Прочитать память процесса
int CloseHandle(HANDLE hObject); -- ＼(＾▽＾)／ Закрыть дескриптор

]]

local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

-- ヾ(＾∇＾) Функция для получения дескриптора текущего активного окна
function getHWND()
    return user32.GetForegroundWindow()
end

-- ヾ(＾∇＾) Функция для получения координат окна по его дескриптору
function getWindowRect(hwnd)
    local rect = ffi.new("RECT")
    user32.GetWindowRect(hwnd, rect)
    return rect
end

-- ヾ(＾∇＾) Функция для получения идентификатора процесса по дескриптору окна
function getProcessID(hwnd)
    local processID = ffi.new("DWORD[1]")
    user32.GetWindowThreadProcessId(hwnd, processID)
    return processID[0]
end

-- ヾ(＾∇＾) Функция для открытия дескриптора процесса с указанными правами доступа
function openProcess(processID, accessRights)
    return kernel32.OpenProcess(accessRights, 0, processID)
end

-- ヾ(＾∇＾) Функция для чтения памяти процесса
function readProcessMemory(processHandle, address, size)
    local buffer = ffi.new("char[?]", size)
    local bytesRead = ffi.new("size_t[1]")
    if kernel32.ReadProcessMemory(processHandle, address, buffer, size, bytesRead) ~= 0 then
        return ffi.string(buffer, bytesRead[0])
    else
        return nil
    end
end

-- ヾ(＾∇＾) Функция для закрытия дескриптора процесса
function closeHandle(handle)
    kernel32.CloseHandle(handle)
end

-- ヾ(＾∇＾) Пример использования функций
local hwnd = getHWND() -- ＼(＾▽＾)／ Получаем дескриптор окна
print("OwO, HWND of the game window:", hwnd)

local rect = getWindowRect(hwnd) -- ＼(＾▽＾)／ Получаем координаты окна
print("Coordinates of the game window (*ﾉωﾉ):", rect.left, rect.top, rect.right, rect.bottom)

local processID = getProcessID(hwnd) -- ＼(＾▽＾)／ Получаем идентификатор процесса
print("Process ID of the game (*´ω｀*):", processID)

local processHandle = openProcess(processID, 0x0010) -- ＼(＾▽＾)／ Открываем процесс для чтения памяти
if processHandle ~= nil then
    local address = 0x12345678 -- ＼(＾▽＾)／ Пример адреса памяти для чтения
    local data = readProcessMemory(processHandle, address, 128) -- ＼(＾▽＾)／ Читаем данные из памяти процесса
    if data ~= nil then
        print("Data read from memory (*≧ω≦):", data)
    else
        print("Failed to read memory (* ; ω ; )")
    end
    closeHandle(processHandle) -- ＼(＾▽＾)／ Закрываем дескриптор процесса
else
    print("Failed to open process (*´･д･)」")
end
