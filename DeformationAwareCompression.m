function DeformationAwareCompression(y,comp_func,compression_parameters)

%parameters:
global to_plot;
global ImName; 
R_start = compression_parameters{1};
R_step = compression_parameters{2};
R_final = compression_parameters{3};
SaveRes = compression_parameters{4};
alpha = compression_parameters{5};
comp_method = compression_parameters{6};
lambda = 0.0012;

%initializations:
yWarp = y;
ux = zeros(size(y,1),size(y,2));
uy = zeros(size(y,1),size(y,2)); 
R_ = R_start:R_step:R_final;
num_of_iter = length(R_);
int_iter = [10 5*ones(1,5) ones(1,num_of_iter-6)];
if strcmp(comp_method,'BPG'), imwrite(y,'temp_BPG.png','png'); end;
if strcmp(comp_method,'Toderici'), imwrite(y,'temp_NN.png','png'); end;

%generating the regularization map:
Map = GenerateAlphaMap(y);
alpha_map = lambda*(1+alpha.*(Map./max(Map(:)))); 


for j=1:num_of_iter    
    R = R_(j); % current compression ratio/quality
    if ~exist('tempFiles','dir'), mkdir('tempFiles'), end
    if strcmp(comp_method,'BPG'), imwrite(y,'tempFiles\org_BPG.png','png'); end;
    if strcmp(comp_method,'NN'), imwrite(y,'tempFiles\org_NN.png','png'); end;
    [ compressed_original] = compression_function(y,R,comp_method,'org_');    
    if j == 1, x = compressed_original; end
    for i = 1:int_iter(j)
        if strcmp(comp_method,'BPG'), imwrite(yWarp,'tempFiles\temp_BPG.png','png'); end;
        if strcmp(comp_method,'NN'), imwrite(yWarp,'tempFiles\temp_NN.png','png'); end;
        [x]= comp_func(yWarp,R); 
        disp(['Compression Rate = ' num2str(R)]);
        [yWarp,ux,uy] = OpticalFlow(x,y,alpha_map,ux,uy);
        if to_plot
            figure(1); 
            suptitle(['R= ' num2str(R) ', Iteration #' num2str(i)])
            subplot(2,2,1); imshow(y); title('Input','Interpreter','LaTeX','Fontsize',12); 
            subplot(2,2,2); imshow(compressed_original); title('Original Compression','Interpreter','LaTeX','Fontsize',12); 
            subplot(2,2,3), imshow(yWarp); title('$\mathcal{T}\{y\}$','Interpreter','LaTeX','Fontsize',12); 
            subplot(2,2,4), imshow(x); title('DA Compression','Interpreter','LaTeX','Fontsize',12); 
            drawnow;
        end
    end
    if (mod(R,SaveRes)==0)
        res_dir = ['Out\' comp_method '\' ImName '\R=' num2str(R)];
        SaveResults( res_dir, x, compressed_original, yWarp, y, R, comp_method);      
    end
end
