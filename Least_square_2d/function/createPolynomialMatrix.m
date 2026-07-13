function A = createPolynomialMatrix(x_data, y_data, n, m)
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
            A(:, col) = (x_data.^i) .* (y_data.^j);
            col = col + 1;
        end
    end
end