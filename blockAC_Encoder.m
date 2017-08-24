function [size_AC,amplitude_AC,runLength_AC,y] = blockAC_Encoder(x)

%breaking down the 8x8 dct quantized block into a column vector using the zig zag
%method

[row col]=size(x);

if row~=col
disp('toZigzag() fails!! Must be a square matrix!!');
return;
end;

y=zeros(row*col,1);
count=1;
for s=1:row
if mod(s,2)==0
for m=s:-1:1
y(count)=x(m,s+1-m);
count=count+1;
end;
else
for m=1:s
y(count)=x(m,s+1-m);
count=count+1;
end;
end;
end;

if mod(row,2)==0
flip=1;
else
flip=0;
end;

for s=row+1:2*row-1
if mod(flip,2)==0
for m=row:-1:s+1-row
y(count)=x(m,s+1-m);
count=count+1;
end;
else
for m=row:-1:s+1-row
y(count)=x(s+1-m,m);
count=count+1;
end;
end;
flip=flip+1;
end;

y=y';
%transpose the column vector into an array

Run_Length = 0;
size_AC =[];
amplitude_AC = [];
runLength_AC = []; 

   for i=2:length(y)
    
    if y(1,i) ==0 &&  i ~=(length(y))
        
        Run_Length=Run_Length +1;
    
    elseif y(1,i)==0 &&  i ==(length(y))
               
             Run_Length=Run_Length +1;
              size_AC = [size_AC,0];
             runLength_AC = [runLength_AC,Run_Length]; 
          amplitude_AC = [amplitude_AC, '0'];        
    end
    
    if y(1,i) >0  
        
       amplitude = dec2bin(y(1,i));          
       size_bin = size(amplitude,2);
       size_AC = [size_AC,size_bin+1]; %size needed to store in binary each number, the extra 1 is for sign
       runLength_AC = [runLength_AC,Run_Length];
       amplitude_AC = [amplitude_AC, strcat('1',amplitude)]; %amplitude_AC in binary. the first 1 is for the positive sign
    Run_Length =0;
    
    end

    if y(1,i) <0  
          
       amplitude = dec2bin((-1)*y(1,i));          
       size_bin = size(amplitude,2);     
       size_AC = [size_AC,size_bin+1]; %size needed to store in binary each number
       runLength_AC = [runLength_AC,Run_Length];
       amplitude_AC = [amplitude_AC, strcat('0',amplitude)]; %amplitude_AC in binary. the first 0 is for the negative sign
    Run_Length =0;
    
    end
    
    end
    
end


