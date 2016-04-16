local Matrix44 = {}
Matrix44.__index = Matrix44;

function Matrix44.new(o)
    local self = setmetatable(o or {}, Matrix44)
    for i = 0, 4 -1 do
        self[i] = self[i] or {};
    end
    self.type = "Matrix44"
    return self;
end

function Matrix44:setName(name)
    self.name = name;
    return self;
end

function Matrix44.construct(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
    local _ = parent or {}
    _[0] = {}; _[0][0] = a; _[0][1] = b; _[0][2] = c; _[0][3] = d;
    _[1] = {}; _[1][0] = e; _[1][1] = f; _[1][2] = g; _[1][3] = h;
    _[2] = {}; _[2][0] = i; _[2][1] = j; _[2][2] = k; _[2][3] = l;
    _[3] = {}; _[3][0] = m; _[3][1] = n; _[3][2] = o; _[3][3] = p;
    return Matrix44.new(_)
end

function Matrix44:identity()
     for i = 0, 4 - 1 do
        self[i][0] = 0;
        self[i][1] = 0;
        self[i][2] = 0;
        self[i][3] = 0;
        self[i][i] = 1;
    end
    return self
end

function Matrix44:rotateAboutBy(x, y, z, angle)
    local c = math.cos(angle);
    local omc = 1.0 - c;
    local s = math.sin(angle);

    local xx = x * x;
    local xy = x * y;
    local xz = x * z;
    local yy = y * y;
    local yz = y * z;
    local zz = z * z;

    local A = Matrix44.construct(
        c, 0, 0, 0,
        0, c, 0, 0,
        0, 0, c, 0,
        0, 0, 0, 1);
    local B = Matrix44.construct(
        xx, xy, xz, 0,
        xy, yy, yz, 0,
        xz, yz, zz, 0,
        0, 0, 0, 0)
    local C = Matrix44.construct(
        0, -z, y, 0,
        z, 0, -x, 0,
        -y, x, 0, 0,
        0, 0, 0, 0)

    return A:sum(B:mul(omc)):sum(C:mul(s))
end

function Matrix44:rotateThisAboutBy(x, y, z, angle)
    return Matrix44:rotateAboutBy(x, y, z):cat(self);
end

function Matrix44:rotation(x, y, z)
    -- zyx
    local cosx = math.cos(x);
    local cosy = math.cos(y);
    local cosz = math.cos(z);
    local sinx = math.sin(x);
    local siny = math.sin(y);
    local sinz = math.sin(z);
    local z = Matrix44.construct(
        1,      0,       0,      0,
        0,      cosx,    -sinx,  0,
        0,      sinx,    cosx,   0,
        0,      0,       0,      1);

    local y = Matrix44.construct(
        cosy,   0,      siny,    0,
        0,      1,      0,       0,
        -siny,  0,      cosy,    0,
        0,      0,      0,       1);

    local x = Matrix44.construct(
        cosz,   -sinz,  0,      0,
        sinz,   cosz,   0,      0,
        0,      0,      1,      0,
        0,      0,      0,      1);

    local yx = y:cat(x)
    return z:cat(yx);
end

function Matrix44:scale(x, y, z)
    return Matrix44.construct(
        x, 0, 0, 0,
        0, y, 0, 0,
        0, 0, z, 0,
        0, 0, 0, 1)
end

function Matrix44:translation(x, y, z)
    return Matrix44.construct(
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z,
        0, 0, 0, 1)
end

function Matrix44:mul(constant)
    assert(type(constant) == "number");
    for i = 0, 4 - 1 do
        self[i][0] = self[i][0] * self[i][0]
        self[i][1] = self[i][1] * self[i][1]
        self[i][2] = self[i][2] * self[i][2]
        self[i][3] = self[i][3] * self[i][3]       
    end
    return self;
end

function Matrix44:mulVec3(v)
    return {
        x = self[0][0] * v.x + self[0][1] * v.y + self[0][2] * v.z + self[0][3] * 1,
        y = self[1][0] * v.x + self[1][1] * v.y + self[1][2] * v.z + self[1][3] * 1,
        z = self[2][0] * v.x + self[2][1] * v.y + self[2][2] * v.z + self[2][3] * 1,
        w = self[3][0] * v.x + self[3][1] * v.y + self[3][2] * v.z + self[3][3] * 1;
    }
end

function Matrix44:cat(m)
    local _ = Matrix44.construct(
        -- RowCol(0, 0) * rhs.RowCol(0, 0) + RowCol(0, 1) * rhs.RowCol(1, 0) + RowCol(0, 2) * rhs.RowCol(2, 0) + RowCol(0, 3) * rhs.RowCol(3, 0), 
        self[0][0] * m[0][0] + self[0][1] * m[1][0] + self[0][2] * m[2][0] + self[0][3] * m[3][0],
        self[0][0] * m[0][1] + self[0][1] * m[1][1] + self[0][2] * m[2][1] + self[0][3] * m[3][1],
        self[0][0] * m[0][2] + self[0][1] * m[1][2] + self[0][2] * m[2][2] + self[0][3] * m[3][2],
        self[0][0] * m[0][3] + self[0][1] * m[1][3] + self[0][2] * m[2][3] + self[0][3] * m[3][3],
        
        self[1][0] * m[0][0] + self[1][1] * m[1][0] + self[1][2] * m[2][0] + self[1][3] * m[3][0],
        self[1][0] * m[0][1] + self[1][1] * m[1][1] + self[1][2] * m[2][1] + self[1][3] * m[3][1],
        self[1][0] * m[0][2] + self[1][1] * m[1][2] + self[1][2] * m[2][2] + self[1][3] * m[3][2],
        self[1][0] * m[0][3] + self[1][1] * m[1][3] + self[1][2] * m[2][3] + self[1][3] * m[3][3],

        self[2][0] * m[0][0] + self[2][1] * m[1][0] + self[2][2] * m[2][0] + self[2][3] * m[3][0],
        self[2][0] * m[0][1] + self[2][1] * m[1][1] + self[2][2] * m[2][1] + self[2][3] * m[3][1],
        self[2][0] * m[0][2] + self[2][1] * m[1][2] + self[2][2] * m[2][2] + self[2][3] * m[3][2],
        self[2][0] * m[0][3] + self[2][1] * m[1][3] + self[2][2] * m[2][3] + self[2][3] * m[3][3],
    
        self[3][0] * m[0][0] + self[3][1] * m[1][0] + self[3][2] * m[2][0] + self[3][3] * m[3][0],
        self[3][0] * m[0][1] + self[3][1] * m[1][1] + self[3][2] * m[2][1] + self[3][3] * m[3][1],
        self[3][0] * m[0][2] + self[3][1] * m[1][2] + self[3][2] * m[2][2] + self[3][3] * m[3][2],
        self[3][0] * m[0][3] + self[3][1] * m[1][3] + self[3][2] * m[2][3] + self[3][3] * m[3][3]
        )
    return _;
end

function Matrix44:sum(o)
    if type(o) == "number" then
        for i = 0, 4 - 1 do
            self[i][0] = self[i][0] + constant;
            self[i][1] = self[i][1] + constant;
            self[i][2] = self[i][2] + constant;
            self[i][3] = self[i][3] + constant;        
        end
    else
        for i = 0, 4 - 1 do
            self[i][0] = self[i][0] + o[i][0];
            self[i][1] = self[i][1] + o[i][1];
            self[i][2] = self[i][2] + o[i][2];
            self[i][3] = self[i][3] + o[i][3];
        end
    end
    return self;
end

function Matrix44:print(message)
    print(message or self.name or "Unnamed Matrix");
    print(self[0][0], self[0][1], self[0][2], self[0][3]);
    print(self[1][0], self[1][1], self[1][2], self[1][3]);
    print(self[2][0], self[2][1], self[2][2], self[2][3]);
    print(self[3][0], self[3][1], self[3][2], self[3][3]);
    return self;
end

return Matrix44;