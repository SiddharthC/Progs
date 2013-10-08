#include<stdio.h>
#include <stdlib.h>

typedef struct qnode{
	struct qnode *prev;
	struct qnode *next;
	int data;
}qnode;

typedef struct queue{
	struct qnode *first;
	struct qnode *last;
}queue;

void insQueue (queue *queue, qnode *temp){

	temp->prev = NULL;
	temp->next = queue->last;
	queue->last = temp;
}

qnode * delQueue(queue *queue){
	if(queue->first == NULL){
		printf("Queue is empty cannot delete");
	}

	qnode *temp = queue->first;
	queue->first = queue->first->prev;
	temp->next = temp->prev = NULL;
	return temp;
}

/************************************************************
  for test only not needed in implementation
  ***********************************************************/

void printQueue(queue *queue){
	qnode *temp = queue->last;

	while(temp != NULL){
		printf("%d\n", temp->data);
		temp = temp->next;
	}
}

int main(int argc, char *argv){

	int i;
	queue *Queue = (queue *)malloc(sizeof(queue));
	Queue->first = Queue->last = NULL;
	qnode *mynode = (qnode *)malloc(5* sizeof(qnode));

	for(i=0; i < 5; i++){
		mynode[i].data = i;
		printf("Insertion - %d\n", i);
		insQueue(Queue, &mynode[i]);
	}
	
	printQueue(Queue);
	return 0;
}
