% Calculate Disparity with built-in methods
ruta1='F:\CATS_Release';
cont=0;
SumaTotal=[0 0];
SumaTotal2=[0 0];
MeanAverage=[0 0];



Suma3 =[0 0];
Suma5 =[0 0];
Suma10 =[0 0];
Suma20 =[0 0];

for x = 1:18
    for y = 1:10
        for z = 1:1
            switch x
                case 1 
                    ruta2='\INDOOR\BOOKS';
                case 2
                    ruta2='\INDOOR\ELECTRONICS';
                case 3 
                    ruta2='\INDOOR\HALLOWEEN';
                case 4
                    ruta2='\INDOOR\MATERIALS';
                case 5 
                    ruta2='\INDOOR\MISC';
                case 6
                    ruta2='\INDOOR\PLANTS';
                case 7 
                    ruta2='\INDOOR\STATUES';
                case 8
                    ruta2='\INDOOR\STORAGE_ROOM';
                case 9 
                    ruta2='\INDOOR\TOOLS';
                case 10
                    ruta2='\INDOOR\TOYS';
                case 11
                    ruta2='\OUTDOOR\CARS';
                case 12
                    ruta2='\OUTDOOR\COURTYARD';
                case 13 
                    ruta2='\OUTDOOR\CREEK';
                case 14
                    ruta2='\OUTDOOR\GARDEN';
                case 15
                    ruta2='\OUTDOOR\HOUSE';
                case 16
                    ruta2='\OUTDOOR\ISE';
                case 17
                    ruta2='\OUTDOOR\PATIO';
                case 18
                    ruta2='\OUTDOOR\SHED';
            end
            y;

            ruta3= strcat('\scene',int2str(y),'\');

            if z == 1
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_default.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_default.png');
            elseif z==2
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_lowLight.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_lowLight.png');
            elseif z==3
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_dark.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_dark.png');
            elseif z==4
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_lowFog.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_lowFog.png');
            elseif z==5
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_highFog.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_highFog.png');
            end
            
            file=strcat(ruta1,ruta2,ruta3,'rectified\color\mask.png');
            
                filenameA =  strcat(ruta1,ruta2,ruta3,'gt_disparity\color\gt_disparity_interp.txt');
                
                filenameB =  strcat(ruta1,ruta2,ruta3,'gt_disparity\color\disp_range.txt');

            if (exist(fileL, 'file') & exist(fileR, 'file') & exist(filenameA, 'file') & exist(filenameB, 'file') )
                    
                            LC= imread(fileL);      %importar imágenes
                            RC= imread(fileR);
                            Mask = imread(file);
                            Mask = im2bw(Mask);
                            cont=cont+1;
                            ruta2;
                            y;

                            [A,delimiterOut]=importdata(filenameA);
                            [B,delimiterOut]=importdata(filenameB);
                            
                            rango = B(2)-B(1);
                            res = mod(rango, 16);
                
                            disparityRange = [B(1) B(2)-res+16];  %definir parámetros
                            contrastThreshold = 0.5;
                            uniquenessThreshold = 0;

                            color_disparity_SG = double(disparity(rgb2gray(LC), rgb2gray(RC), ...
                            'Method', 'SemiGlobal', 'DisparityRange', disparityRange, ...
                            'ContrastThreshold', contrastThreshold, ...
                            'UniquenessThreshold', uniquenessThreshold));
                            
                            color_disparity_BM = double(disparity(rgb2gray(LC), rgb2gray(RC), ...
                            'Method', 'BlockMatching', 'DisparityRange',disparityRange, ...
                            'ContrastThreshold', contrastThreshold, ...
                            'UniquenessThreshold', uniquenessThreshold));
            
                            A = max(A, B(1));
                            A = min(A, B(2));
                            
                            color_disparity_SG = max(color_disparity_SG, B(1));   %Eliminar valores fuera del rango
                            color_disparity_SG = min(color_disparity_SG, B(2)); 
                            
                            color_disparity_BM = max(color_disparity_BM, B(1)); 
                            color_disparity_BM = min(color_disparity_BM, B(2));
                            
                            %error = [abs(color_disparity_SG - A) abs(color_disparity_BM - A)];                %Calcular error por pixel
                            %error = [error(1).*Mask error(2).*Mask];
                                                       
                            %MeanMask = mean2(Mask);
                            %Mean = [mean2(error(1))/MeanMask mean2(error(2))/MeanMask]                       %Calcular error promedio
                            
                            counter=0;
                            SumaError = [0 0];
                            SumaTau3=[0 0];
                            SumaTau5=[0 0];
                            SumaTau10=[0 0];
                            SumaTau20=[0 0];
                            for i=1:960
                                for j=1:1280
                                    if(Mask(i,j)==1)
                                        counter = counter + 1;
                                        SumaError = [SumaError(1) + abs(color_disparity_SG(i,j) - A(i,j)) SumaError(2) + abs(color_disparity_BM(i,j) - A(i,j))];
                                        if(abs(color_disparity_SG(i,j) - A(i,j)) < 3)  SumaTau3(1)= SumaTau3(1) + 1; end
                                        if(abs(color_disparity_SG(i,j) - A(i,j)) < 5)  SumaTau5(1)= SumaTau5(1) + 1; end
                                        if(abs(color_disparity_SG(i,j) - A(i,j)) < 10)  SumaTau10(1)= SumaTau10(1) + 1; end
                                        if(abs(color_disparity_SG(i,j) - A(i,j)) < 20)  SumaTau20(1)= SumaTau20(1) + 1; end
                                        
                                        if(abs(color_disparity_BM(i,j) - A(i,j)) < 3)  SumaTau3(2)= SumaTau3(2) + 1; end
                                        if(abs(color_disparity_BM(i,j) - A(i,j)) < 5)  SumaTau5(2)= SumaTau5(2) + 1; end
                                        if(abs(color_disparity_BM(i,j) - A(i,j)) < 10)  SumaTau10(2)= SumaTau10(2) + 1; end
                                        if(abs(color_disparity_BM(i,j) - A(i,j)) < 20)  SumaTau20(2)= SumaTau20(2) + 1; end
                                    end
                                end
                            end
                            
                            MeanRec = [SumaError(1)/counter SumaError(2)/counter]
                            
                            Mean3R = [SumaTau3(1) / counter SumaTau3(2) / counter];
                            Mean5R = [SumaTau5(1) / counter SumaTau5(2) / counter];
                            Mean10R = [SumaTau10(1) / counter SumaTau10(2) / counter];
                            Mean20R = [SumaTau20(1) / counter SumaTau20(2) / counter];
                            
                            %tau3(error <= 3) = 1;
                            %tau3(error > 3) = 0;
                            %tau5(error <= 5) = 1;
                            %tau5(error > 5) = 0;
                            %tau10(error <= 10) = 1;
                            %tau10(error > 10) = 0;
                            %tau20(error <= 20) = 1;
                            %tau20(error > 20) = 0;
                             
                            %Mean3 = mean2(tau3).*MeanMask;
                            %Mean5 = mean2(tau5).*MeanMask;
                            %Mean10 = mean2(tau10).*MeanMask;
                            %Mean20 = mean2(tau20).*MeanMask;
                            
                            %SumaTotal= [SumaTotal(1) + Mean(1) SumaTotal(2) + Mean(2)];
                            SumaTotal2 = [SumaTotal2(1) + MeanRec(1) SumaTotal2(2) + MeanRec(2)];
                            
                            Suma3 = [Suma3(1) + Mean3R(1) Suma3(2) + Mean3R(2)];
                            Suma5 = [Suma5(1) + Mean5R(1) Suma5(2) + Mean5R(2)];
                            Suma10 = [Suma10(1) + Mean10R(1) Suma10(2) + Mean10R(2)];
                            Suma20 = [Suma20(1) + Mean20R(1) Suma10(2) + Mean20R(2)];
                
            end
            

        end
    end
end
imshow(color_disparity_SG,disparityRange);  %Mostrar resultado ultimo calculo
title('Resultado');
MeanTau3=Suma3/cont;
MeanTau5=Suma5/cont;
MeanTau10=Suma10/cont;
MeanTau20=Suma20/cont;
%MeanAverage = SumaTotal/cont;
MeanAverage2 = SumaTotal2/cont;
par = {'N° Imagenes','Mean Error','t=3','t=5','t=10','t=20'};
Datos1= [cont,MeanAverage2(1), MeanTau3(1), MeanTau5(1), MeanTau10(1), MeanTau20(1)];
Datos2= [cont,MeanAverage2(2), MeanTau3(2), MeanTau5(2), MeanTau10(2), MeanTau20(2)];
T = table; %(par',Datos1',Datos2')
T.Resultado = par';
T.SG = Datos1';
T.BM = Datos2'
