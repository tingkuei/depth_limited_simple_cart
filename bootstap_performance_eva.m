clear;
clc;
X=load('hw3_train.txt');
D=load('hw3_test.txt');
%matlabpool open local 4


Y=X(:,size(X,2));
data_size=size(X,1);
out_size=size(D,1)
Y2=D(:,size(D,2));

% bootstrap
Bootstrap_data=[];
forest=[];

tree_num=300;
repeat_times=300;
RF_err=0;
err=0;
g_err=0;
gt_avg=0;
Eout=0;
for k=1:repeat_times
    ii=k
    Bootstrap_data=[];
    forest=[];
    for j=1:tree_num
      for i=1:data_size
          Bootstrap_data=[Bootstrap_data; X(randi(data_size),:)];
      end
      temp_tree=CART(Bootstrap_data,0);
      forest=[forest temp_tree];
      Bootstrap_data=[];
    end
    for i=1:data_size
       score=0;
       for j=1:tree_num
           result=0;
           tree=forest(j);
           while tree.result ==0
               theda=tree.theda;
               dim=tree.dim;
               if sign(X(i,dim)-theda) ==1
                   tree=tree.right;
               else
                   tree=tree.left;
               end
           end
           result=tree.result;
           if sign(result) ~= Y(i)
                g_err=g_err+1;
           end
           score=score+result;
       end
       gt_avg=gt_avg+g_err;
       g_err=0;
       if sign(score) ~= Y(i)
            err=err+1;
       end   
    end
    for i=1:out_size
       score=0;
       for j=1:tree_num
           result=0;
           tree=forest(j);
           while tree.result ==0
               theda=tree.theda;
               dim=tree.dim;
               if sign(D(i,dim)-theda) ==1
                   tree=tree.right;
               else
                   tree=tree.left;
               end
           end
           result=tree.result;
           score=score+result;
       end
            if sign(score) ~= Y2(i)
            Eout=Eout+1;
       end   
    end
end
gt_avg=gt_avg/(data_size*tree_num*repeat_times)
err=err/(data_size*repeat_times)
Eout=Eout/(out_size*repeat_times)
%matlabpool close
%{
tree=CART(X,5);
temp=tree;
err=0;
for i=1:data_size
   result=0;
   tree=temp;
   while tree.result ==0
       theda=tree.theda;
       dim=tree.dim;
       if sign(X(i,dim)-theda) ==1
           tree=tree.right;
       else
           tree=tree.left;
       end
   end
   result=tree.result;
   if result ~= Y(i)
      err=err+1;
   end
end
err=err/data_size


err=0;
%}