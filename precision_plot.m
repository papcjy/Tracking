function precisions = precision_plot(positions, ground_truth, title, show, contrast, tld, struck, mil, ct)
%PRECISION_PLOT
%   Calculates precision for a series of distance thresholds (percentage of
%   frames where the distance to the ground truth is within the threshold).
%   The results are shown in a new figure if SHOW is true.
%
%   Accepts positions and ground truth as Nx2 matrices (for N frames), and
%   a title string.
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/

	
	max_threshold = 50;  %used for graphs in the paper
	
	
	precisions = zeros(max_threshold, 1);
    precisions1 = zeros(max_threshold, 1);   	
	precisions2 = zeros(max_threshold, 1);
    precisions3 = zeros(max_threshold, 1);
    precisions4 = zeros(max_threshold, 1);
	
	if size(positions,1) ~= size(ground_truth,1),
% 		fprintf('%12s - Number of ground truth frames does not match number of tracked frames.\n', title)
		
		%just ignore any extra frames, in either results or ground truth
		n = min(size(positions,1), size(ground_truth,1));
		positions(n+1:end,:) = [];
		ground_truth(n+1:end,:) = [];
	end
	
	%calculate distances to ground truth over all frames
	distances = sqrt((positions(:,1) - ground_truth(:,1)).^2 + ...
				 	 (positions(:,2) - ground_truth(:,2)).^2);
	distances(isnan(distances)) = [];
    
    
	%compute precisions
	for p = 1:max_threshold,
		precisions(p) = nnz(distances <= p) / numel(distances);
    end
	
    %compare with tld,struck,mil,ct
    distances1 = sqrt((tld(:,1) - ground_truth(:,1)).^2 + ...
                     (tld(:,2) - ground_truth(:,2)).^2);
    distances1(isnan(distances1)) = [];
    for p = 1:max_threshold,
        precisions1(p) = nnz(distances1 <= p) / numel(distances1);
    end
    distances2 = sqrt((struck(:,1) - ground_truth(:,1)).^2 + ...
                     (struck(:,2) - ground_truth(:,2)).^2);
    distances2(isnan(distances2)) = [];
    for p = 1:max_threshold,
        precisions2(p) = nnz(distances2 <= p) / numel(distances2);
    end
    distances3 = sqrt((mil(:,1) - ground_truth(:,1)).^2 + ...
                     (mil(:,2) - ground_truth(:,2)).^2);
    distances3(isnan(distances3)) = [];
    for p = 1:max_threshold,
        precisions3(p) = nnz(distances3 <= p) / numel(distances3);
    end    
    distances4 = sqrt((ct(:,1) - ground_truth(:,1)).^2 + ...
                     (ct(:,2) - ground_truth(:,2)).^2);
    distances4(isnan(distances4)) = [];
    for p = 1:max_threshold,
        precisions4(p) = nnz(distances4 <= p) / numel(distances4);
    end 
    
    
    
	%plot the precisions
	if show == 1,
		figure('Number','off', 'Name',['Precisions - ' title])
		plot(precisions, 'k-', 'LineWidth',2)
		xlabel('Threshold'), ylabel('Precision')
        hold on
        plot(contrast(:,1), 'g--', 'LineWidth',2) %contrast with kcf
        hold on
        plot(precisions1, 'b--', 'LineWidth',2)
        plot(precisions2, 'r--', 'LineWidth',2)
        plot(precisions3, 'm--', 'LineWidth',2)
        plot(precisions4, 'y--', 'LineWidth',2)
        legend('Proposed','KCF','TLD','Struck','MIL','CT');
	end
	
end

