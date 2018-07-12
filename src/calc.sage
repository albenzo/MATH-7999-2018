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

def shift_braid(Bg,b,k):
    return Bg([ sign(s)*(abs(s)+k) for s in b.Tietze()])

def thicken_crossing(i,n,m):
    # only use positive i, just invert after placing in braid
    return [j for k in range(i,i+m) for j in range(k+n-1,k-1,-1)]

def populate_list(n,braids,components):
    lst = []
    offset=1
    
    for i in range(1,n+1):
        j = index_in_sublist(i,components)
        if i == comps[j][0]:
            lst.append((others[j],offset))
        else:
            lst.append((BraidGroup((others[j].strands()))([]),offset))
        offset += others[j].strands()
        
    return lst

def sorted_braid_components(braid):
    return sorted([list(comp) for comp in braid.permutation().to_cycles()],key =lambda x: x[0])

def immerse_braids(braid,others):
    comps = sorted_braid_components(braid)
    
    n = sum([others[i].strands() * len(comps[i]) for i in range(len(comps))])
    B = BraidGroup(n)

    other_locs = populate_list(braid.strands(),others,comps)

    colored = prod([shift_braid(B,b,loc-1) for (b,loc) in other_locs])

    for x in braid.Tietze():
        colored *= B(thicken_crossing(other_locs[x-1][1],other_locs[x-1][0].strands(),other_locs[x][0].strands()))
        i,j = index_in_sublist(x,comps),index_in_sublist(x+1,comps)
        others[j],others[i] = others[i],others[j]
        other_locs = populate_list(braid.strands(),others,comps)
        
    return colored

def I(A,M):
    raise NotImplementedError
