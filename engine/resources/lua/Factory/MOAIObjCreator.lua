local MOAIObjCreator = require("./Factory/Creator"):new();

--[[
    For each face edge e where an edge = {v1, v2}
        for each e
            create a new half edge he
                he.head = v2
                he.face = currentFace
            push he to face.halfEdges
            if v1 not visited
                set v1.outgoing = he
            memo v1 to v2 as having he
            if reverse (v2 to v1) is in memo. This means we have a twin.
                he.twin = reverse half edge from memo
                reverse half edge from memo.twin = he
        Hook up each half edge in face to form a circular reference to each other
            face.halfEdges[1].next = face.halfEdges[2]
            face.halfEdges[2].next = face.halfEdges[3]
            face.halfEdges[3].next = face.halfEdges[1]
            
        
--]]
local function halfEdgeFromFacesAndVertexList(faces, vertices)

    local function createHalfEdge(head, face)
        return {head = head, face = face}
    end

    local function handleFaceEdge(face, v1, v2)
        local he = createHalfEdge(v2, face);
        table.insert(face.halfEdges, he);
        he.face = face;
        face.edge = face.edge or he;
        
        v1.visited = true;
        v1.outgoing = v1.outgoing or he;
        
        v1[v2] = he;
        if v2[v1] ~= nil then
            he.twin = v2[v1];
            v2[v1].twin = he;
        end
        
    end

    for index, face in pairs(faces) do
        face.halfEdges = face.halfEdges or {}
        
        handleFaceEdge(face, face.v1, face.v2);
        handleFaceEdge(face, face.v2, face.v3);
        handleFaceEdge(face, face.v3, face.v1);
        
        face.halfEdges[1].next = face.halfEdges[2]
        face.halfEdges[2].next = face.halfEdges[3]
        face.halfEdges[3].next = face.halfEdges[1]
    end

    -- local path = "../models/";
    -- local outfile = io.open(path.."cubetestout.txt", "wt");
    -- writeDebugInformation(faces, vertices);
    -- writeFaceDebugInformation(outfile, faces);

end

-- MOAIObjCreator
function MOAIObjCreator:create(properties)
    local obj = require("ResourceManager"):load("Obj", properties.fileName);
    return obj;
end
-- MOAIObjCreator

return function(factory) 
    return MOAIObjCreator;
end