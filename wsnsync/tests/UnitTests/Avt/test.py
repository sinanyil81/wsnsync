import sys
from TOSSIM import *

t = Tossim([])
r = t.radio()

t.addChannel("TestAppC", sys.stdout)

# Booting nodes
t.getNode(0).bootAtTime(0);

# runNextEvent returns the next even
for i in range(0, 25000):
  t.runNextEvent()
  