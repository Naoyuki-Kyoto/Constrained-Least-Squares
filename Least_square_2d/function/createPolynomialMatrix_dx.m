function A = createPolynomialMatrix_dx(x_data, y_data, n, m)
    % 入力:
    % x_data, y_data: データベクトル
    % n: x の最大次数
    % m: y の最大次数
    % 出力:
    % A: 多項式フィッティング行列
    
    % データの長さを確認
    num_data = length(x_data);
    
    % A行列を初期化
    A = zeros(num_data, (n + 1) * (m + 1));
    
    % 行列を埋める
    col = 1; % 列インデックス
    for i = 0:n
        for j = 0:m
            if i == 0
                A(:, col) = 0;
            else
                A(:, col) = - (i) * (x_data.^(i-1)) .* (y_data.^j);
            end
            col = col + 1;
        end
    end
end