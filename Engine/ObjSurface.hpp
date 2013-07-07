#include "Interfaces.hpp"
#include "Vectors.h"

class ObjSurface : public ISurface {
public:
    ObjSurface(const string& name);
    int GetVertexCount() const;
    void Generate();
    int GetLineIndexCount() const { return 0; }
    int GetTriangleIndexCount() const;
    void GenerateVertices(vector<float>& vertices, unsigned char flags) const;
    void GenerateLineIndices(vector<unsigned short>& indices) const {}
    void GenerateTriangleIndices(vector<unsigned short>& indices) const;
private:
    string m_name;
    vector<ivec3> m_faces;
    mutable size_t m_faceCount;
    mutable size_t m_vertexCount;
    static const int MaxLineSize = 128;
    
    vector<CC3Vector> _vertices;
    vector<CC3Vector> _normals;
    vector<GLushort> _elements;
};
