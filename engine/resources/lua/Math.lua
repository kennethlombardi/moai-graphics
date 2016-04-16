local Math = {}
local Matrix = require("Matrix")

Math.Constants = {
    FLOAT_MAX = 2147483640,
}

function Math:dot3(v1, v2)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
end

function Math:vertex3Sub(v1, v2)
    local x = v1.x - v2.x;
    local y = v1.y - v2.y;
    local z = v1.z - v2.z;
    return {x = x, y = y, z = z}
end

function Math:vertex3Sum(v1, v2)
    return {x = v1.x + v2.x, y = v1.y + v2.y, z = v1.z + v2.z}
end

function Math:vertex3Mul(v, factor)
    v.x = v.x * factor;
    v.y = v.y * factor;
    v.z = v.z * factor;
    return v;
end

function Math:vertex3Cross(v1, v2)
    return {x = v1.y * v2.z - v1.z * v2.y,
            y = v1.z * v2.x - v1.x * v2.z,
            z = v1.x * v2.y - v1.y * v2.x}
end

-- given sphere s and point p update s (if needed) to just encompass p
function Math:sphereOfSphereAndPt(s, p)
    -- compute squared distance between point and sphere center
    local d = Math:vertex3Sub(p, s.c);
    local dist2 = Math:dot3(d, d);

    -- only update s if point p is outside it
    if dist2 > (s.r * s.r) then 
        local dist = math.sqrt(dist2);
        local newRadius = (s.r + dist) * 0.5;
        local k = (newRadius - s.r) / dist;
        s.r = newRadius;
        s.c = Math:vertex3Sum(Math:vertex3Mul(d, k), s.c); -- s.c + d * k;
    end
    return s;
end

-- an iteration over all the points to ensure that no points
--  lie outside of the sphere
-- If a point is encountered outside the current sphere a new larger
--  sphere is computed
function Math:growSphere(vertices, sphere)
    for k,v in pairs(vertices) do 
        Math:sphereOfSphereAndPt(sphere, v);
    end
    return sphere;
end

function Math:getExtremePointsAlongDirection(direction, vertices)
    local FLOAT_MAX = Math.Constants.FLOAT_MAX;
    local minproj = FLOAT_MAX;
    local maxproj = -FLOAT_MAX;
    local extremal = {vmin = {x = 0, y = 0, z = 0}, vmax = {x = 0, y = 0, z = 0}}

    for key, vertex in pairs(vertices) do 
        local proj = Math:dot3(vertex, direction);

        if proj < minproj then
            minproj = proj;
            extremal.vmin = vertex;
        end

        if proj > maxproj then
            maxproj = proj
            extremal.vmax = vertex
        end
    end

    return extremal
end

-- compute indices to the two most separated points of the (up to) six points
-- defining the AABB encompassing the point set. Return these as min and max
local function mostSeparatedPointsOnAABB(vertices)
    local minx = {x = 0, y = 0, z = 0};
    local maxx = {x = 0, y = 0, z = 0};
    local miny = {x = 0, y = 0, z = 0};
    local maxy = {x = 0, y = 0, z = 0};
    local minz = {x = 0, y = 0, z = 0};
    local maxz = {x = 0, y = 0, z = 0};

    -- first find most extreme points along principal axis
    for k,v in pairs(vertices) do 
        if v.x < minx.x then minx = v end
        if v.x > maxx.x then maxx = v end
        if v.y < miny.y then miny = v end
        if v.y > maxy.y then maxy = v end
        if v.z < minz.z then minz = v end
        if v.z > maxz.z then maxz = v end 
    end

    -- compute the squared distances for the three pairs of points
    local distx = Math:vertex3Sub(maxx, minx)
    local dist2x = Math:dot3(distx, distx);

    local disty = Math:vertex3Sub(maxy, miny);
    local dist2y = Math:dot3(disty, disty);

    local distz = Math:vertex3Sub(maxz, minz);
    local dist2z = Math:dot3(distz, distz);

    -- pick the pair (min, max) of points most distant
    local min = minx;
    local max = maxx;

    if dist2y > dist2x and dist2y > dist2z then
        max = maxy;
        min = miny;
    end

    if dist2z > dist2x and dist2z > dist2y then
        max = maxz;
        min = minz;
    end

    return min, max;
end

local function sphereFromDistantPoints(s, vertices)
    -- find the most separated point pair defining the encompassing AABB
    local minPoint, maxPoint = mostSeparatedPointsOnAABB(vertices);

    -- set up sphere to just encompass these two points
    -- s.c = (min + max) * .5
    local p = minPoint;
    local q = maxPoint;
    local difference = Math:vertex3Sub(q, p);
    local halfWayPoint = Math:vertex3Sum(p, Math:vertex3Mul(difference, .5));
    s.c = halfWayPoint;

    -- Dot(maxPoint - s.c, maxPoint - s.c) 
    s.r = Math:dot3(Math:vertex3Sub(maxPoint, s.c), Math:vertex3Sub(maxPoint, s.c));

    --s.c = {x = 4, y = 4, z = 4};
    s.r = math.sqrt(s.r);

    return s;
end

function Math:ritterSphere(s, vertices)
    sphereFromDistantPoints(s, vertices);
    for k,v in pairs(vertices) do 
        Math:sphereOfSphereAndPt(s, v)
    end
    return s;
end

function Math:minimumSphere(E)
    return sphereFromDistantPoints({}, E);
    -- return Math:ritterSphere({r = 0, c = {x = 0, y = 0, z = 0}}, E); 
end

function Math:getCentroid(vertices)
    local x = 0;
    local y = 0;
    local z = 0;
    local vertexCount = #vertices;
    for k,v in pairs(vertices) do 
        x = x + v.x;
        y = y + v.y;
        z = z + v.z;
    end
    local centroid = {x = x / vertexCount, y = y / vertexCount, z = z / vertexCount}
    return centroid
end

function Math:getCentroidOfMultipleObjs(objs)
    local centroids = {}
    for i,v in pairs(objs) do 
        table.insert(centroids, Math:getCentroid(v.vertices));
    end
    return Math:getCentroid(centroids);
end

local function symSchur2(a, p, q, c, s)
    if math.abs(a[p][q]) > 0.0001 then
        local r = (a[q][q] - a[p][p]) / (2.0 * a[p][q]);
        local t = 0.0;
        if r >= 0 then
            t = 1.0 / (r + math.sqrt(1.0 + r * r));
        else
            t = -1.0 / (-r + math.sqrt(1.0 + r * r));
        end
        c = 1.0 / math.sqrt(1.0 + t * t);
        s = t * c;
    else
        c = 1.0;
        s = 0.0;
    end
    return c, s;
end

function Math:covarianceMatrix(cov, vertices) 
    local oon = 1 / #vertices;
    local e00 = 0;
    local e11 = 0;
    local e22 = 0;
    local e01 = 0;
    local e02 = 0;
    local e12 = 0;
    local c = Math:getCentroid(vertices)

    -- compute covariance elements
    for k, v in pairs(vertices) do
        local p = Math:vertex3Sub(v, c);

        -- compute covariance of translated points
        e00 = e00 + p.x * p.x;
        e11 = e11 + p.y * p.y;
        e22 = e22 + p.z * p.z;
        e01 = e01 + p.x * p.y;
        e02 = e02 + p.x * p.z;
        e12 = e12 + p.y * p.z;
    end

    -- fill in the covariance matrix elements
    Matrix.RowColVal(cov, 0, 0, e00 * oon);
    Matrix.RowColVal(cov, 1, 1, e11 * oon);
    Matrix.RowColVal(cov, 2, 2, e22 * oon);
    Matrix.RowColVal(cov, 0, 1, e01 * oon); Matrix.RowColVal(cov, 1, 0, e01 * oon);
    Matrix.RowColVal(cov, 0, 2, e02 * oon); Matrix.RowColVal(cov, 2, 0, e02 * oon);
    Matrix.RowColVal(cov, 1, 2, e12 * oon); Matrix.RowColVal(cov, 2, 1, e12 * oon);

    return cov;
end

function Math:jacobi(a, v)
    local i;
    local j;
    local n;
    local p;
    local q;
    local prevoff = 0;
    local c = 0;
    local s = 0;
    local J = {};

    -- initialize v to identity matrix
    Matrix.identity(v);

    -- repeat for some maximum number of iterations
    local MAX_ITERATIONS = 50;
    for n = 0, MAX_ITERATIONS - 1 do
        -- find largest off-diagonal absolute element a[p][q]
        p = 0; q = 1;
        for i = 0, 3 - 1 do 
            for j = 0, 3 - 1 do 
                if i == j then
                    continue = 3;
                elseif math.abs(a[i][j]) > math.abs(a[p][q]) then
                    p = i;
                    q = j;
                end
            end
        end

        -- compute the jacobi rotation matrix J(p, q, theta)
        c, s = symSchur2(a, p, q, c, s)

        -- initialize J to identity matrix
        Matrix.identity(J);
        J[p][p] = c;
        J[p][q] = s;
        J[q][p] = -s;
        J[q][q] = c;

        -- cumulate rotations into what will contain the eigenvectors
        v = Matrix.concatenate(v, J);

        -- make 'a' more diagonal until just eigenvalues remain on diagonal
        local J = Matrix.transpose(J);
        local JTransposed_Cat_a = Matrix.concatenate(J, a);
        a = Matrix.concatenate(JTransposed_Cat_a, J);

        -- compute norm of off-diagonal elements
        local off = 0;
        for i = 0, 3 - 2 do
            for j = 0, 3 - 2 do 
                if i == j then
                   asdfasfdasdf = 3;
                else 
                    local aij = a[i][j];
                    off = off + aij * aij
                end
            end
        end

        -- stop when norm no longer decreasing
        if n > 2 and off >= prevoff then
            return a, v
        end

        prevoff = off
    end -- compute for some MAX_ITERATIONS
    return a, v;
end

return Math;