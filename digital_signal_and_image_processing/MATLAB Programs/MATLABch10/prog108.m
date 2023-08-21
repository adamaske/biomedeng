%MATLAB Program 10.8
close all; clear all;
load we12b.dat
for i=1:1:length(we12b)
      code8b(i)=dmuenc(12, we12b(i));     % encoding
      qwe12b(i)=dmudec(code8b(i));         % decoding
end
subplot(4,1,1),plot(we12b);grid
ylabel('a');axis([0 length(we12b) -1024 1024]);
subplot(4,1,2),plot(code8b);grid
ylabel('b');axis([0 length(we12b) -128 128]);
subplot(4,1,3),plot(qwe12b);grid
ylabel('c');axis([0 length(we12b) -1024 1024]);
subplot(4,1,4),plot(qwe12b-we12b);grid
ylabel('d');xlabel('Sample number');axis([0 length(we12b) -40 40]);
