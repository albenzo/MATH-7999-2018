B = BraidGroup(2)

U = Knot(B([]))
U_pos = Knot(B([1]))
U_neg = Knot(B([-1]))

def chebychev_poly(a,n):
    return (-1)^(n)*(a^(2*(n+1))-a^(-2*(n+1)))/(a^2-a^(-2))

def s_n(a):
    raise NotImplementedError

def omega(a,r):
    return sum([chebychev_poly(a,n)*s_n(a) for n in range(r-2)])

def index_in_sublist(i,lst):
    for j in range(len(lst)):
        if i in lst[j]:
            return j

def shift_braid(b,k):
    return [ sign(s)*(abs(s)+k) for s in b.Tietze()]

def thicken_crossing(i,n,m):
    # only use positive i, just invert after placing in braid
    return [j for k in range(i,i+m) for j in range(k+n-1,k-1,-1)]

def immerse_braids(braid,others):
    comps = sorted([list(comp) for comp in braid.permutation().to_cycles()],key= lambda x: x[0])
    
    n = sum([others[i].strands() * len(comps[i]) for i in range(len(comps))])
    B = BraidGroup(n)

    offset = 1
    comp_starts = []
    for i in range(1,len(others)+1):
        j = index_in_sublist(i,comps)
        if i == comps[j][0]:
            comp_starts.append(offset)
        offset += others[j].strands()
        
    in_place_braids = []
    j=0
    for i in range(n):
       if j < len(comp_starts) and i+1 == comp_starts[j]:
           in_place_braids.append(B(shift_braid(others[j],i)))
           j += 1
    
    b = prod(in_place_braids)

    for x in braid.Tietze():
        # setup thicken_crossing with correct i, n, and m
        # find a way to remember where everything lands
        # multiply b on the right
        # don't worry about matching the numbers since it will end up lining up with another cycle
        # if done correctly

    return b

def I(A,M):
    raise NotImplementedError
