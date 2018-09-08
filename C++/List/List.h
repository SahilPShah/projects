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
  //delete the list
  void deleteList();
  //reverse the list;
  void reverse();


private:
  class Node{
    T & data_;
    Node* next_;
    Node(T & data);
  }
  Node* head_;
}
