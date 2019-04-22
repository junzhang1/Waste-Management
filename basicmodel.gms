SET   i   trash generation sites ;
SET   j   landfill sites ;
SET   s   scenarios ;


PARAMETERS
      T(i,s)   Trash generated at site i in scenario s
      XC(i)    X coordinate of site i
      YC(i)    Y coordinate of site i
      XL(j)    X coordinate of landfill j
      YL(j)    Y coordinate of landfill j
      

$gdxin basicmodel_inputs
$load i,j,s,T,XC,YC,XL,YL
$gdxin


VARIABLES
        L(j)      1 if landfill j is selected
        A(i,j)    1 if site i is assigned to landfill j
        z         objective function
        TD        total distance
        TL        total landfills sites chosen


        

BINARY VARIABLES L,A;
POSITIVE VARIABLES TD,TL;


EQUATIONS
    capacity(j,s)         capacity type constraint used to relate assignment and build
    totaldistance         total distance between all sites and their assigned landfills
    totallandfills        total number of landfills to build
    objective             define weight based multi objective function
    assignment(i)         ensure each site is allocated to only 1 landfill
;



capacity(j,s)..           sum((i), A(i,j)*T(i,s))=l=L(j)*4000000;  
totaldistance..           TD=e=sum((i,j), (abs(XC(i)-XL(j)) + abs(YC(i)-YL(j)))*A(i,j));
totallandfills..          TL=e=sum((j), L(j)); 
objective..               z=e=(0.985*TL + 0.015*TD);
assignment(i)..           sum((j), A(i,j))=e=1;


MODEL basicmodel/all/ ;

basicmodel.OptCR = 0.001

SOLVE basicmodel using mip minimizing z;

execute_unload 'basicmodel_output', z, TL, TD, L, A;





    


    
