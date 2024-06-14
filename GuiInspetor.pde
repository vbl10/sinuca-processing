interface GuiInspetorVarRef
{
  String apurarValor();
}
class GuiInspetor extends GuiComponente
{
  Coord pos;
  GuiInspetorVarRef varRef;
  public GuiInspetor(Coord pos, GuiInspetorVarRef varRef)
  {
    this.pos = pos;
    this.varRef = varRef;
  }
  
  @Override
  public void desenhar()
  {
    fill(255);
    textAlign(LEFT, TOP);
    text(varRef.apurarValor(), pos.x, pos.y);
  }
}
