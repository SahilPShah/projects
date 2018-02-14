#ifndef LIST_H_
#define LIST_H_

template <typename T>
class List{
public:
  //insert an element
  void insert(T & data);
  //remove an element
  void remove(T & data);
  //calculate the size of an element
  int size();
  //create an empty list
  void create();


private:
  class Node{
    T & data_;
    Node* next;
    Node(T & data);
  }
  Node* head_;
}
