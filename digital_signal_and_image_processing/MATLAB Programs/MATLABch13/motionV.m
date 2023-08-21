function [u,v, min_MAD]=motionV(cur_block,ref_block)
%  search the motion vector for 16x16 image blocks.
% Definition: function [u,v, min_MAD]=motionV(cur_block,ref_block)
% Input: 
%        cur_block = block in the target frame
%        ref_block = block in the referenece frame
% Output:
%        u = horizontal displacement from the reference block
%        v = vertical displacement from the reference block
%        min_MAD = minimum abosolute error
	min_MAD=10^10;
      for i=1:17
        for j=1:17
            cur_MAD=abs(cur_block-ref_block(i:i+15,j:j+15));
            cur_MAD=sum(cur_MAD(:));
            cur_MAD=sum(cur_MAD(:));
            if (cur_MAD <min_MAD)
                min_MAD=cur_MAD;
                u=i;v=j;
            end
        end
    end
        