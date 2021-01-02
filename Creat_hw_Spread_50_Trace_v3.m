
tic

dataset_dir = 'dataset'; % thay doi cho moi BYTE 
byte_attack= 1;
mkdir (dataset_dir);
for i = 0:255
   dir = fullfile(dataset_dir,sprintf('key_%d',i));
    mkdir (dir,'hw3');
    mkdir (dir,'hw4');
    mkdir (dir,'hw5');
end

% Declare SBOX (might be useful to calculate the power hypothesis)
SBOX=[099 124 119 123 242 107 111 197 048 001 103 043 254 215 171 118 ...
      202 130 201 125 250 089 071 240 173 212 162 175 156 164 114 192 ...
      183 253 147 038 054 063 247 204 052 165 229 241 113 216 049 021 ...
      004 199 035 195 024 150 005 154 007 018 128 226 235 039 178 117 ...
      009 131 044 026 027 110 090 160 082 059 214 179 041 227 047 132 ...
      083 209 000 237 032 252 177 091 106 203 190 057 074 076 088 207 ...
      208 239 170 251 067 077 051 133 069 249 002 127 080 060 159 168 ...
      081 163 064 143 146 157 056 245 188 182 218 033 016 255 243 210 ...
      205 012 019 236 095 151 068 023 196 167 126 061 100 093 025 115 ...
      096 129 079 220 034 042 144 136 070 238 184 020 222 094 011 219 ...
      224 050 058 010 073 006 036 092 194 211 172 098 145 149 228 121 ...
      231 200 055 109 141 213 078 169 108 086 244 234 101 122 174 008 ...
      186 120 037 046 028 166 180 198 232 221 116 031 075 189 139 138 ...
      112 062 181 102 072 003 246 014 097 053 087 185 134 193 029 158 ...
      225 248 152 017 105 217 142 148 155 030 135 233 206 085 040 223 ...
      140 161 137 013 191 230 066 104 065 153 045 015 176 084 187 022];

%%%%%%%%%%%%%%%%%%%%
% LOADING the DATA %
%%%%%%%%%%%%%%%%%%%%
numberOfTrace= 50; 
numberOfTraces= 4000; 

key=readNPY('Trace/keylist.npy');
disp('THE KEY:');
disp(key(1,:));
plaintext=readNPY('Trace/textin.npy');
ciphertext=readNPY('Trace/textout.npy');
disp('THE ciphertext:');
disp(plaintext(1,:));
traces1=readNPY('Trace/traces.npy');
traces1=traces1(1:50,:);

traces1 = [traces1;traces1;traces1;traces1;traces1;
           traces1;traces1;traces1;traces1;traces1];
traces1 = [traces1;traces1;traces1;traces1;
           traces1;traces1;traces1;traces1];
       
drop1 = round(rand(4000,25));
drop2 = round(rand(4000,25));
one   = ones(4000,950);
Drop = [drop1,one,drop2];
%%%%%%%%%%%%%%%%%%%%%%%%%
K = 4000;
for kk = 1:K
    Drop(kk,:) = circshift(Drop(kk,:),kk,2);
end
traces1 = traces1.*Drop;
M = 4000;
for mm = 1:M
    %traces1(mm,:) = circshift(traces1(mm,:),mm,2); 
	traces1(mm,:) = circshift(traces1(mm,:),randi([0 20]),2);
end
plaintexts = [plaintext;plaintext;plaintext;plaintext;plaintext;
              plaintext;plaintext;plaintext;plaintext;plaintext];
plaintexts = [plaintexts;plaintexts;plaintexts;plaintexts;
              plaintexts;plaintexts;plaintexts;plaintexts];
%%
for BYTE=1:byte_attack % run from first byte to 16-th byte
    
     inter = zeros(numberOfTraces,1);
   
     for KEY = 0:255 %0:255
            for t = 1:numberOfTraces
            
            inter(t,1) = bitxor(plaintexts(t,BYTE),KEY);
            inter(t,1) = SBOX(inter(t,1)+1);
            inter(t,1) = sum(bitget(inter(t,1),1:8));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
            hw = inter(t,1);     
            s  = traces1(t,:);

            switch hw 
                case 3            
                    newfile = fullfile(dataset_dir,sprintf('key_%d',KEY),'hw3',sprintf('key_0_%d',t));
                    save(newfile,'s');

                    
                case 4                       
                    newfile = fullfile(dataset_dir,sprintf('key_%d',KEY),'hw4',sprintf('key_0_%d',t));
                    save(newfile,'s');
                    
                
                case 5                         
                    newfile = fullfile(dataset_dir,sprintf('key_%d',KEY),'hw5',sprintf('key_0_%d',t));
                    save(newfile,'s');
            end
            
            end
            
     end

end

toc