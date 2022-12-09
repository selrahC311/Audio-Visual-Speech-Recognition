v = VideoReader("xylophone.mp4");
vidHeight = v.Height;
vidWidth = v.Width;
x = read(v,1);

%image is 240 by 320
x=x(1:240, 1:240, :);
x=double(x);
r=x(:,:,1); 
g=x(:,:,2);
b=x(:,:,3);
%xgray=0.2126*r+0.7152*g+0.0722*b;
%xgray=uint8(xgray);
%figure(1);imagesc(xgray);colormap(gray);
p=8; % loss parameter
Q=p*[16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55 ;
    14 13 16 24 40 57 69 56 ;
    14 17 22 29 51 87 80 62 ;
    18 22 37 56 68 109 103 77; 
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99;];

image= zeros(240,240,2); % 640 by 640 matrix
for i = 1:8:240
    for j = 1:8:240
       %red
        R=r(i:i+7, j:j+7); %extract an 8 by 8 pixel block
        Rd=double(R);
        Rc=Rd-128;
        C=dct(Rc);
        RY=C*Rc*C';
       %Matrix that is widely used currently %linear quantization matrix
        RYq=round(RY./Q);
            
        %to recover the image back
        RYdq=RYq.*Q; 
        Rdq=C'*RYdq*C;
        Re=Rdq+128;
      %blue 
        B=b(i:i+7, j:j+7); %extract an 8 by 8 pixel block
        Bd=double(B);
        Bc=Bd-128;
        C=dct(Bc);
        BY=C*Bc*C';
       %Matrix that is widely used currently %linear quantization matrix
        BYq=round(BY./Q);
            
        %to recover the image back
        BYdq=BYq.*Q; 
        Bdq=C'*BYdq*C;
        Be=Bdq+128;
        
        %GREEN
        G=g(i:i+7, j:j+7); %extract an 8 by 8 pixel block
        Gd=double(G);
        Gc=Gd-128;
        C=dct(Gc);
        GY=C*Gc*C';
       %Matrix that is widely used currently %linear quantization matrix
        GYq=round(GY./Q);
            
        %to recover the image back
        GYdq=GYq.*Q; 
        Gdq=C'*GYdq*C;
        Ge=Gdq+128;
        
        image(i:i+7,j:j+7,1)=Re;
        image(i:i+7,j:j+7,2)=Ge;
        image(i:i+7,j:j+7,3)=Be;
        
    end
end
image=uint8(image);
figure(4);imagesc(image);