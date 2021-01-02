 matOject = matfile('accuracy_mlp_0.025.mat','Writable',true); 
 keyAcc = matOject.keyAccuracy;
 trans_keyAcc=transpose(keyAcc);
% sz=size(trans_keyAcc);
% disp(sz);
% plot(

 x = [1 3 5 7 10 12 14 16 19 21 23 25 28 30];
 y = transpose(trans_keyAcc(1:14,:));
 y1= transpose(trans_keyAcc(1:14,44));
 %disp(y);  
 h = plot(x,y,'b');

 hold on
 h1 = plot(x,y1,'r');
 h1.LineWidth = 2;
 axis([0 31 28 60]);
 set(gca,'FontSize',14)
 %title('Training Accuracies')
 xlabel('Number of Epochs','FontName','Times New Roman','FontSize', 18)
 ylabel('Validation Accuracy','FontName','Times New Roman','FontSize', 18)
% ylabel('Validation Accuracy','FontName', 'Times New Roman','FontWeight','bold','FontSize', 18)
 hold off
% set(h, {'color'}, {[0.5 0.5 0.5]; [1 0 0]});