class Coord
{
  public float x, y;
  Coord(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  Coord() 
  {
    this.x = 0.0f;
    this.y = 0.0f;
  }
  
  Coord def(float x, float y)
  {
    this.x = x;
    this.y = y;
    return this;
  }
  
  float mag2()
  {
    return this.x * this.x + this.y * this.y;
  }
  float mag()
  {
    return sqrt(this.mag2());
  }
  Coord unidade()
  {
    return this.div(this.mag());
  }
  
  float ponto(Coord b)
  {
    return this.x * b.x + this.y * b.y;
  }
  Coord soma(Coord b)
  {
    return new Coord(this.x + b.x, this.y + b.y);
  }
  Coord sub(Coord b)
  {
    return new Coord(this.x - b.x, this.y - b.y);
  }
  Coord mult(float b)
  {
    return new Coord(this.x * b, this.y * b);
  }
  Coord div(float b)
  {
    return new Coord(this.x / b, this.y / b);
  }
};
