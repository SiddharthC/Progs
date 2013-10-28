//C implementation of LRU cache

typedef struct _QNode{
    QNode *prev, *next;
    unsigned pageNum;
}QNode;

typedef struct __Queue{
    unsigned countFilledFrames;
    unsigned numberOfFrames;
    QNode *front, *rear;
}Queue;

QNode* createQueue(int numberOfFrames){
    Queue *queue = (Queue *)malloc(sizeof)(Queue));
    queue->count = 0;
    queue->front = queue->rear = NULL;
    
    queue->numberOfFrames = numberOfFrames;
    
    return queue; 
}

typedef struct Hash{
    int capacity;
    QNode* *array;    //array of QNode

}Hash;

Hash* createHash(int capacity){
    Hash* hash = (Hash *)malloc (sizeof(Hash));
    hash->capacity = capacity;
    
    hash->array = (Hash **) malloc(hash->capacity* sizeof(QNode *));
    
    int i;
    for(i=0; i<hash->capacity; i++){
        hash->array[i] = NULL;
    }
    
    return hash;
}

int isQueueEmpty(Queue *queue){
    reurn queue->rear == NULL;
}

void deQueue(Queue *queue){
    if (isQueueEmpty(queue))
        return;
    
    if (queue->front == queue->rear)
        queue->front = NULL;
        
    Queue *temp = queue->rear;
    queue->rear = queue->rear->prev;
    
    if(queue->rear)
        queue->rear->next = NULL;
        
    free(temp);        
}

QNode* newQNode(unsigned pageNum){
    QNode *temp = (QNode *) malloc(sizeof (QNode));
    temp->pageNum = pageNum;
    
    temp->prev = temp->next = NULL;
    
    return temp;
}

int AreAllFramesFull(Queue *queue){
    return queue->count == queue->numberOfFrames;
}

void enQueue(Queue *queue, Hash *hash, unsigned pageNum){
    
    if(AreAllFramesFull(queue)){
        hash->array[queue->rear->pageNum] = NULL;
        deQueue(queue);
    }
    
    
    Queue *temp = newQNode( pageNum);
    
    temp->next = queue->front;
    
    if(isEmpty(queue)){
        queue->rear = queue->front = temp;
    }
    
    else{
        queue->front->prev = temp;
        queue->front = temp;
    }

    hash->array[pageNum] = temp;
    
    queue->count++;
}

void ReferencePage(Queue *queue, Hash *hash, unsigned pageNum){  //This is the important function
    
    Queue *reqPage = hash->array[pageNum];
    
    if(reqPage == NULL){
        enQueue(queue, hash, pageNum);
    }
    else if(reqPage != queue->front){
        
        //This is problematic
        
        //unlink from current location 
        reqPage->prev->next = reqPage->next;
        if(reqPage->next){
            reqPage->next->prev = req->prev;
        }
        
        if(reqPage == queue->rear){
            queue->rear = reqPage->prev;
            queue->rear->next = NULL;
        }
        
        reqPage->next = queue->front;
        reqPage->prev = NULL;
        
        reqPage->next->prev = reqPage;
        
        queue->front = reqPage;
        
    }
    
    return reqPage;
}