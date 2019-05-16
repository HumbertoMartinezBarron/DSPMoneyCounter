x = rgb2gray(imread('Monedas/monedasEncimadas1.jpg'));
h = fspecial('log');
filtrada = imfilter(imfilter(x,h),h);
binaria = imbinarize(filtrada);
SE = strel('disk',6,4);
dilatada = imdilate(binaria,SE);
y = imfill(dilatada,'holes');
y = bwareafilt(y,[300,50000]);
subplot(2,1,1)
imshow(x),title('Imagen en blanco y negro')
subplot(2,1,2)
imshow(y),title('Imagen procesada')
pause(2)
clf
[I,J] = ind2sub(size(y),find(y));
plot(I,J,'.'), title('Puntos de interes')
cc = bwconncomp(y);
tams = zeros(cc.NumObjects*2,1);
for i = 1:cc.NumObjects
    [I, J] = ind2sub(size(y),cc.PixelIdxList{i});
    u = unique(I);
    z = zeros(size(u));
    for j = 1:size(z,1), z(j) = sum(I == u(j)); end
    m1 = max(z);
    d = sum(cumsum(z==m1)<=sum(z==m1)/2) + 1;
    if d-m1/2 <= 10
        r = (z((d+uint8(m1/2)):size(z,1)));
    else
        r = (z(1:(d-uint8(m1/2))));
    end
    if size(r,1)<=10
        m2 = 0;
    else
        m2 = max(r);
    end
    tams(i) = m1;
    tams(size(tams,1)+1-i) = m2;
end
monedas_detectadas = size(find(tams),1)
A1 = 0;
A2 = 0;
if monedas_detectadas >= 25
    mitad = size(y,1)/2;
    arriba = {};
    abajo = {};
    a1 = 1;
    a2 = 1;
    for i=1:cc.NumObjects
        [I, J] = ind2sub(size(y),cc.PixelIdxList{i});
        if max(I) <= mitad
            arriba{a1} = tams(i);
            arriba{a1+1} = tams(size(tams,1)+1-i);
            a1 = a1 + 2;
        else
            abajo{a2} = tams(i);
            abajo{a2+1} = tams(size(tams,1)+1-i);
            a2 = a2 + 2;
        end
    end
    A1 = cell2mat(arriba);
    A2 = cell2mat(abajo);
    subplot(2,1,1)
    histogram(A1(A1~=0),20)
    subplot(2,1,2)
    histogram(A2(A2~=0),20)
else
    histogram(tams(tams~=0),23)
end
valores = [0.5,1,5,10];
if A1 == 0
    if monedas_detectadas <= 10
        h = histcounts(tams(tams~=0),12); 
    else
        h = histcounts(tams(tams~=0),23);
    end
    monedas = zeros(4,1);
    c = 1;
    flag = 1;
    for i=1:size(h,2)
        if h(i)
            flag = 1;
            monedas(c) = monedas(c) + h(i);
        else
            if flag, c = c + 1; flag = 0; end
        end
    end
    cincuenta_centavos = monedas(1)
    un_peso = monedas(2)
    cinco_pesos = monedas(3)
    diez_pesos = monedas(4)
    total = valores*monedas
else
    h = histcounts(A2(A2~=0),20);
    monedas = zeros(4,1);
    c = 1;
    flag = 1;
    for i=1:size(h,2)
        if h(i)
            flag = 1;
            monedas(c) = monedas(c) + h(i);
        else
            if flag, c = c + 1; flag = 0; end
        end
    end
    h = histcounts(A1(A1~=0),20);
    m = [h(1); sum(h(6:9)); sum(h(14:16)); sum(h(17:20))];
    monedas = monedas + m;
    cincuenta_centavos = monedas(1)
    un_peso = monedas(2)
    cinco_pesos = monedas(3)
    diez_pesos = monedas(4)
    total = valores*monedas
end