local Matrix33 = {}

-- set [row][col] to val
function Matrix33.RowColVal(self, row, col, val)
    if self[row] == nil then
        self[row] = {}
    end

    self[row][col] = val;
end

function Matrix33.identity(self)
    for i = 0, 3 - 1 do
        Matrix33.RowColVal(self, i, 0, 0);
        Matrix33.RowColVal(self, i, 1, 0);
        Matrix33.RowColVal(self, i, 2, 0);
        Matrix33.RowColVal(self, i, i, 1);
    end
    return self
end

function Matrix33.mul(a, b)
    for i = 0, 3 - 1 do
        a[i][0] = a[i][0] * b[i][0];
        a[i][1] = a[i][1] * b[i][1];
        a[i][2] = a[i][2] * b[i][2];
    end
    return a;
end

function Matrix33.concatenate(a, b)
    local res = Matrix33.identity({});
    local rcv = Matrix33.RowColVal;

    rcv(res, 0, 0, a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0]);
    rcv(res, 0, 1, a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1]);
    rcv(res, 0, 2, a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2] * b[2][2]);

    rcv(res, 1, 0, a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0]);
    rcv(res, 1, 1, a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1]);
    rcv(res, 1, 2, a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2] * b[2][2]);

    rcv(res, 2, 0, a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0]);
    rcv(res, 2, 1, a[2][0] * b[0][1] + a[2][1] * b[1][1] + a[2][2] * b[2][1]);
    rcv(res, 2, 2, a[2][0] * b[0][2] + a[2][1] * b[1][2] + a[2][2] * b[2][2]);

    return res;
end

function Matrix33.transpose(self)
    local res = Matrix33.identity({});
    local rcv = Matrix33.RowColVal;
    rcv(res, 0, 0, self[0][0]); rcv(res, 0, 1, self[1][0]); rcv(res, 0, 2, self[2][0]); --rcv(res, 0, 3, self[3][0]); 
    rcv(res, 1, 0, self[0][1]); rcv(res, 1, 1, self[1][1]); rcv(res, 1, 2, self[2][1]); --rcv(res, 1, 3, self[3][1]); 
    rcv(res, 2, 0, self[0][2]); rcv(res, 2, 1, self[1][2]); rcv(res, 2, 2, self[2][2]); --rcv(res, 2, 3, self[3][2]); 
    --rcv(res, 3, 0, self[0][3]); rcv(res, 3, 1, self[1][3]); rcv(res, 3, 2, self[2][3]); rcv(res, 3, 3, self[3][3]); 
    return res;
end

function Matrix33.print(self, title)
    title = title or "Unnamed Matrix"
    print(title);
    print(self[0][0], self[0][1], self[0][2]);
    print(self[1][0], self[1][1], self[1][2]);
    print(self[2][0], self[2][1], self[2][2]);

end

function Matrix33.write(self, file, title)
    title = title or "Unnamed Matrix"
    file:write(title.."\n");
    file:write(self[0][0] .. ", " .. self[0][1] .. ", " .. self[0][2] .. "\n");
    file:write(self[1][0] .. ", " .. self[1][1] .. ", " .. self[1][2] .. "\n");
    file:write(self[2][0] .. ", " .. self[2][1] .. ", " .. self[2][2] .. "\n"); 
end


return Matrix33;