% Calculate Disparity with built-in methods
ruta1='F:\CATS_Release';
cont=0;
SumaTotal=0;
MeanAverage=0;
Suma3=0;
Suma5=0;
Suma10=0;
Suma20=0;
for x = 1:18
    for y = 1:10
        for z = 1:5
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
                fileL=strcat(ruta1,ruta2,ruta3,'rectified\color\left_color_lowligth.png');
                fileR=strcat(ruta1,ruta2,ruta3,'rectified\color\right_color_lowligth.png');
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

            if exist(fileL, 'file')
                if exist(fileR, 'file')
                    if exist(filenameA, 'file')
                        if exist(filenameB, 'file')
                            LC= imread(fileL);      %importar imágenes
                            RC= imread(fileR);
                            Mask = imread(file);
                            Mask = im2bw(Mask);
                            cont=cont+1
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

                            color_disparity_SG = color_disparity_SG.*Mask;
                            A = A.*Mask;

                            newmatrix = max(color_disparity_SG, B(1));   %Eliminar valores fuera del rango
                            newmatrix = min(newmatrix, B(2)); 

                            A = max(A, B(1));
                            A = min(A, B(2));
                            
                            error = abs(newmatrix - A);                 %Calcular error por pixel
                            %MeanMask = mean2(Mask);
                            Mean = mean2(error);                        %Calcular error promedio
                            
                            
    
                            tau3(error <= 3) = 1;
                            tau3(error > 3) = 0;
                            tau5(error <= 5) = 1;
                            tau5(error > 5) = 0;
                            tau10(error <= 10) = 1;
                            tau10(error > 10) = 0;
                            tau20(error <= 20) = 1;
                            tau20(error > 20) = 0;
                             
                            Mean3 = mean2(tau3);
                            Mean5 = mean2(tau5);
                            Mean10 = mean2(tau10);
                            Mean20 = mean2(tau20);
                            
                            SumaTotal= SumaTotal + Mean;
                            Suma3 = Suma3 + Mean3;
                            Suma5 = Suma5 + Mean5;
                            Suma10 = Suma10 + Mean10;
                            Suma20 = Suma20 + Mean20;
                        end
                    end
                end
            end
            

        end
    end
end

MeanAverage=SumaTotal/cont

MeanTau3=Suma3/cont
MeanTau5=Suma5/cont
MeanTau10=Suma10/cont
MeanTau20=Suma20/cont

imshow(color_disparity_SG,disparityRange);  %Mostrar resultado de el ultimo par de imagen
title('SG');
