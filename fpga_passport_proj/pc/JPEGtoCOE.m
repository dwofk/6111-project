%function img2 = IMG2coe8(imgfile, outfile)
% imgfile = input .jpg file
% outfile = output .coe file
% Example:
%http://www.lbebooks.com/downloads/exportal/vhdl_nexys_example24.pdf
% img2 = IMG2coe8('paris240x160.jpg', 'paris240x160.coe');
img = imread('paris640x480.jpg');
height = size(img, 1);
width = size(img, 2);
s = fopen('paris.coe','wb');  %opens the output file
fprintf(s,'%s\n','; VGA Memory Map ');
fprintf(s,'%s\n','; .COE file with hex coefficients ');
fprintf(s,'; Height: %d, Width: %d\n\n', height, width);
fprintf(s,'%s\n','memory_initialization_radix=16;');
fprintf(s,'%s\n','memory_initialization_vector=');
cnt = 0;
%img2 = img;
for r=1:height
    for c=1:width
        cnt = cnt + 1;
        R = img(r,c,1);
        G = img(r,c,2);
        B = img(r,c,3);
        Rb = dec2bin(R,8);
        Gb = dec2bin(G,8);
        Bb = dec2bin(B,8);
%         img2(r,c,1) = bin2dec([Rb(1:5) '000']);
%         img2(r,c,2) = bin2dec([Gb(1:6) '00']);
%         img2(r,c,3) = bin2dec([Bb(1:5) '000']);
        Outbyte = [Rb(1:5) Gb(1:6) Bb(1:5)];
        fprintf(s,Outbyte);
        
%         if (Outbyte(1:4) == '0000')
%             fprintf(s,'0%X',bin2dec(Outbyte));
%         else
%             fprintf(s,'%X',bin2dec(Outbyte));
%         end
%         if ((c == width) && (r == height))
%             fprintf(s,'%c',';');
%         else
%             if (mod(cnt,32) == 0)
%                 fprintf(s,'%c\n',',');
%             else
%                 fprintf(s,'%c',',');
%             end
%         end
    end
end
fclose(s);
