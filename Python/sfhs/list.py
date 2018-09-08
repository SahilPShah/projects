class _Node(object):
    def __init__(self, data=None, next=None):
        self.data = data
        self.next = next

    def get_data(self):
        return self.data

    def get_next(self):
        return self.next

    def set_next(self, next):
        self.next = next


class LinkedList(object):

    def __init__(self, head = None):
        self.head = head

    def insert(self, data):
        node = _Node(data)
        node.set_next(self.head)
        self.head = node

    def size(self):
        current = self.head;
        count = 0
        while current:
            count+=1
            current = current.get_next()
        return count
