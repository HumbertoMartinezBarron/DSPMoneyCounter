x = rgb2gray(imread('Monedas/monedas4.jpg'));
h = fspecial('log');
filtrada = imfilter(imfilter(x,h),h);
binaria = imbinarize(filtrada);
SE = strel('disk',5,4);
dilatada = imdilate(binaria,SE);
y = imfill(dilatada,'holes');
y = bwareafilt(y,[200,50000]);
subplot(2,1,1)
imshow(x),title('Imagen en blanco y negro')
subplot(2,1,2)
imshow(y),title('Imagen procesada')
pause(2)
clf
[I,J] = ind2sub(size(y),find(y));
plot(I,J,'.'), title('Puntos de interes')
cc = bwconncomp(y);
tams = zeros(cc.NumObjects,1);
for i=1:size(tams,1)
    tams(i) = size(cc.PixelIdxList{i},1);
end
cincuenta_centavos = (tams<=4050);
un_peso = (tams <= 6000).*(1-cincuenta_centavos);
diez_pesos = (tams > 8200);
cinco_pesos = (tams >=6500) .* (1-diez_pesos);
sum(cincuenta_centavos)*0.5 + sum(un_peso) + sum(diez_pesos)*10 + sum(cinco_pesos)*5