function [DCcoeff_decoded,DCdiff_decoded,ACcoeff_decoded,decoded_img] = block_decoder(img_rows,img_col,img_dim,size_ACC,runLength_ACC, amplitude_ACC, size_DC,amplitude_DC)

size_ACC=double(size_ACC);
runLength_ACC = double(runLength_ACC);
size_DC=double(size_DC);

%code for reconstructing DCdiff_decoded and DC_DCcoeff_decoded;

DCdiff_decoded = [];


for i=1:length(size_DC)
     

  if i~=length(size_DC)
    
    if size_DC(i)~=0 
    
    amplitude = bin2dec(amplitude_DC(2:size_DC(i)));
    
      if amplitude_DC(1) == '0'
      amplitude = (-1)*amplitude;   
      end
    
    DCdiff_decoded = [DCdiff_decoded,amplitude];
    amplitude_DC = amplitude_DC((size_DC(i)+1):end);
   
   end
    
    if size_DC(i)==0
        
      amplitude = 0;
      DCdiff_decoded = [DCdiff_decoded,amplitude];
      amplitude_DC = amplitude_DC((size_DC(i))+2:end); 
    end
    
  end
    
  if i==length(size_DC)
  
    if size_DC(i)~=0 
    
    amplitude = bin2dec(amplitude_DC(2:size_DC(i)));
    
      if amplitude_DC(1) == '0'
      amplitude = (-1)*amplitude;   
      end
    
    DCdiff_decoded = [DCdiff_decoded,amplitude];
   
   end
    
    if size_DC(i)==0
        
      amplitude = 0;
      DCdiff_decoded = [DCdiff_decoded,amplitude];
    end 
   
    break
  end 
    
end

DCcoeff_decoded = [];

DCcoeff_decoded(1) = DCdiff_decoded(1);


for i=2:length(DCdiff_decoded)   
    
   x= DCdiff_decoded(i)+DCcoeff_decoded(i-1);

DCcoeff_decoded = [DCcoeff_decoded,x];    
    
end


%code for reconstructing AC_coeff ;

ACcoeff_decoded =[];

for i=1:length(size_ACC)
    
    if size_ACC(i)~=0 
    
    amplitude = bin2dec(amplitude_ACC(2:size_ACC(i)));
    
      if amplitude_ACC(1) == '0'
      amplitude = (-1)*amplitude;   
      end
    
    ACcoeff_decoded = [ACcoeff_decoded,zeros(1,runLength_ACC(i)),amplitude];
    amplitude_ACC = amplitude_ACC((size_ACC(i)+1):end);
   
    end
    
    
    if size_ACC(i)==0 
        
     ACcoeff_decoded = [ACcoeff_decoded,zeros(1,runLength_ACC(i))];
     amplitude_ACC = amplitude_ACC(((size_ACC(i))+2):end);   
      
    end


end



decoded_img = zeros(img_rows,img_col,img_dim);
blockv1 = [];

%code for reconstructing the image block by block
    
%     
for dim = 1:img_dim
   
    for i=1:8:img_rows
    
        for j = 1:8:img_col
       
           blockv1 = [DCcoeff_decoded(1),ACcoeff_decoded(1:63)];
           blockv1=invZigzag(blockv1);%%
           blockv2 = idct2(blockv1);
           decoded_img(i:i+7,j:j+7,dim) = blockv2;
           DCcoeff_decoded = DCcoeff_decoded(2:end);
           ACcoeff_decoded = ACcoeff_decoded(64:end);
           
        end
    end
end

end