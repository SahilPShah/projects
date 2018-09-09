class Stack:
    def __init__(self):
        stack = []

    def push(self, data):
        self.stack.append(data)

    def pop(self):
        return self.stack.pop(0)

    def peek(self):
        return self.stack[0]

    def size(self):
        return len(self.stack)
    
    def isEmpty(self):
        if self.size() != 0:
            return False
        return True
