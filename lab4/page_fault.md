# Page Fault 學習筆記

### Page Fault 定義
每當程式訪問到page不在主mem時發生的異常，因為MMU(記憶體管理單元)，無法在分頁表找到對應的項目(但在頁表是標記無效或不在記憶體內)

### Virtual memory的好處
* 擴充可用的記憶體空間
* 提供記憶體隔離和保護 (**isolation**) // 
  * usr and kernel 之間的隔離保護
* 簡化程式的記憶體使用
  * va -> pa
  
關於VM 會有幾個功能是常見的
* lazy allocation 
* mmap
* cow and write fork
* demand paging
#### 當遇到Page Fault 時，kernel需要什麼樣的資訊？
* The faulting of va 
* the type of page fault
* the va of instruction that cased the fault
* sbrk

#### Page Fault 類型
1. 輕微分頁錯誤
   發生原因：
2. 嚴重分頁錯誤
3. 無效分頁錯誤

### Page Fault 處理機制

1.CPU 偵測到 Page Fault
2.儲存目前程序狀態（暫存器、程式計數器等）
3.切換到核心模式，呼叫 Page Fault 處理程式
4.確定 Page Fault 類型和原因
5.對於嚴重錯誤，從磁碟讀取所需分頁
6.更新分頁表，建立虛擬位址到實體位址的對應
7.如果需要，執行分頁替換演算法
8.恢復程序狀態，返回使用者模式
9.重新執行導致 Page Fault 的指令

Page Fault 在系統中的應用
1.LRU（最近最少使用）：替換最長時間沒用到的分頁
2.Clock 演算法：LRU 的近似實作，效率更高
3.FIFO（先進先出）：替換最早進入記憶體的分頁
4.最佳分頁替換（理論演算法）：替換最長時間內不會被使用的分頁

