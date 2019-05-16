% imagen con ruido
x = rgb2gray(imread('Monedas/monedasRuido2.jpg'));
h = fspecial('log');
noNoise = medfilt2(x, [5,5]); %Para ruido
binaria = imbinarize(noNoise, 'adaptive','ForegroundPolarity','bright','Sensitivity',0.62);
SE = strel('disk',1,4);
dilatada = imdilate(binaria,SE);
v = imcomplement(dilatada);
y = imfill(v,'holes');
y = bwareafilt(v,[200,50000]);
subplot(2,1,1)
imshow(x),title('Imagen en blanco y negro')
subplot(2,1,2)
imshow(binaria),title('Imagen procesada')
pause(2)
clf

[I,J] = ind2sub(size(y),find(y));
plot(I,J,'.'), title('Puntos de interes')
cc = bwconncomp(y);
tams = zeros(cc.NumObjects,1);
for i=1:size(tams,1)
    tams(i) = size(cc.PixelIdxList{i},1);
end

%para ruido
cincuenta_centavos = (tams<=2500);
un_peso = (tams<=4000).*(1-cincuenta_centavos);
diez_pesos = (tams > 5500); 
cinco_pesos = (tams >=4000) .* (1-diez_pesos); 

thresh = 0.5; 
maskPhoto = y > thresh;
coinLocs = regionprops(maskPhoto,'Centroid');
nCoins = size(coinLocs,1);
nCoins
tot50 = sum(cincuenta_centavos)
tot1 = sum(un_peso)
tot10 = sum(diez_pesos)
tot5 = sum(cinco_pesos)
totalMonedas = sum(cincuenta_centavos)*0.5 + sum(un_peso) + sum(diez_pesos)*10 + sum(cinco_pesos)*5
