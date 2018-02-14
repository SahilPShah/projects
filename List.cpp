#include "List.h"
#include <iostream>
template typename <T>
Node::Node(T & data){
  data_=data;
  next_=NULL;
  prev_=NULL:
}

void List::insert(T & data){
  Node *e = new Node(data);
  //copy head pointer
  Node* temp = head_;
  //set next to current head
  e->next_ = temp;
  //set new head to pointer of node
  head = e;
}
void remove(T & data){
//IMPLEMENT
}
