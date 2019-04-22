SET   i   trash generation sites ;
SET   j   landfill sites ;
SET   k   stations;


PARAMETERS
      T(i)     Trash generated at site i
      XC(i)    X coordinate of site i
      YC(i)    Y coordinate of site i
      XL(j)    X coordinate of landfill j
      YL(j)    Y coordinate of landfill j
      XT(k)    X coordinate of transfer station k
      YT(k)    Y coordinate of transfer station k
      

$gdxin model_with_stations_inputs
$load i,j,k,T,XC,YC,XL,YL,XT,YT
$gdxin


VARIABLES
        L(j)      1 if landfill j is selected
        B(k)      1 if station k is selected
        A(i,k)    Amount of trash from site to station 
        D(k,j)    Amount of trash from station to landfill
        W(i,j)    Amount of trash from site to landfill 
        z         objective function
        TD        total distance
        TL        total landfill sites chosen
        TS        total stations sites chosen
        N(i,k)    if site i sends any trash to station k
        O(i,j)    if site i sends any trash to landfill j
        M(k,j)    if station k sends any trash to landfill j


        
BINARY VARIABLES L,B,N,M,O;
POSITIVE VARIABLES A,D,W,TD,TL,TS;


EQUATIONS
    capacity_landfill(j)           capacity type constraint used to relate assignment and build of landfill
    capacity_station(k)            capacity type constraint used to relate assignment and build of station
    totaldistance                  total distance between all sites and their assigned landfills
    totalbuildlandfill             total number of landfills to build
    totalbuildstation              total number of stations to build 
    objective                      define weight based multi objective function
    assign_site_station(i,k)       if site i assigned to station k
    assign_station_landfill(k,j)   if station k assigned to landfill j
    assign_site_landfill(i,j)      if site i assigned to landfill j
    trash_out_site(i)              all trash in site should leave
    trash_out_station(k)           all trash from station should leave
;


assign_site_station(i,k)..       A(i,k)=l=N(i,k)*T(i);
assign_station_landfill(k,j)..   D(k,j)=l=M(k,j)*5000000;
assign_site_landfill(i,j)..      W(i,j)=l=O(i,j)*T(i);
capacity_landfill(j)..           sum((i), W(i,j))+ sum((k),D(k,j))=l=L(j)*4000000;
capacity_station(k)..            sum((i), A(i,k))=l=B(k)*4000000;  
totaldistance..                  TD=e=sum((i,j), (abs(XC(i)-XL(j)) + abs(YC(i)-YL(j)))*O(i,j))+sum((i,k), (abs(XC(i)-XT(k)) + abs(YC(i)-YT(k)))*N(i,k))+sum((j,k), 0.5*(abs(XT(k)-XL(j)) + abs(YT(k)-YL(j)))*M(k,j));
totalbuildlandfill..             TL=e=sum((j), L(j));
totalbuildstation..              TS=e=sum((k),B(k));
objective..                      z=e=(0.9999*(0.2*TL + 0.8*TS)+0.0001*TD);
trash_out_site(i)..              sum((k), A(i,k)) + sum((j),W(i,j))=e=T(i);
trash_out_station(k)..           sum((i), 0.5*A(i,k))=e=sum((j), D(k,j));



MODEL model_transfer_stations/all/ ;

model_transfer_stations.OptCR = 0.001

SOLVE model_transfer_stations using mip minimizing z;

execute_unload 'model_transfer_stations_output', B, D, W, N, M, O, z, TL, TD, TS, L, A, T;



























    


    
