class _Node(object):
    def __init__(self, data=None, next=None):
        self.data = data
        self.next = next

    def getData(self):
        return self.data

    def getNext(self):
        return self.next

    def setNext(self, next):
        self.next = next


class LinkedList(object):

    def __init__(self, head = None):
        self.head = head

    def insert(self, data):
        node = _Node(data)
        node.setNext(self.head)
        self.head = node

    def size(self):
        current = self.head;
        count = 0
        while current:
            count+=1
            current = current.getNext()
        return count

    def search(self,data):
        current = self.head
        while current:
            if current.getData() == data:
                return data
            current = current.getNext()
        if current is None:
            raise ValueError("Data is not in list")

    def delete(self, data):
        current = self.head
        previous = None
        found = False
        while current and found is False:
            if current.getData() == data:
                found = True
            else:
                previous = current
                current = current.getNext()
        if current is None:
            raise ValueError("Data not in list")
        if previous is None:
            self.head = current.getNext()
        else:
            previous.set_next(current.getNext())
