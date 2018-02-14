EXENAME = test
OBJS = list.o

CXX = clang++
CXXFLAGS = -c -stdlib=libc++ -g -Wall -Werror -pedantic
LD = clang++
LDFLAGS = -stdlib=c++ -lpthread -lm

$(EXENAME) : $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $(EXENAME)

list.o : list.cpp list.h
	$(CXX) $(CXXFLAGS) list.cpp
