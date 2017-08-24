function [size_DC,amplitude_DC] = blockDC_Encoder(DC_diff)

size_DC = [];
amplitude_DC = [];
size_bin =0;
amplitude =0;

for i=1:length(DC_diff)
    
    if DC_diff(i)<0
    
   amplitude = dec2bin((-1)*DC_diff(i));     
   size_bin = size(amplitude,2);
   size_DC = [size_DC, size_bin+1];
   amplitude_DC = [amplitude_DC, strcat('0', amplitude)];  
        
    end
    
    if DC_diff(i)>0
  
   amplitude = dec2bin(DC_diff(i));          
  size_bin = size(amplitude,2);
  size_DC = [size_DC, size_bin+1];
  amplitude_DC = [amplitude_DC, strcat('1', amplitude)];  
    
    end
    
if DC_diff(i)==0
        
  size_DC = [size_DC,0];
  amplitude_DC = [amplitude_DC, '0'];  
    
end
     
     
 end
    
size_DC = uint8(size_DC);    
    
end
