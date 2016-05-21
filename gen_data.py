import sys, random

def gen_one():
    print ''.join(random.choice('ATCG') for c in xrange(1000))

if len(sys.argv)>1:
    gen_one()
else:
    [gen_one() for ll in xrange(3000)]
