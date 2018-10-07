program Builder;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
(*Product - final object that will be created by Director using Builder*)
  TPizza = class
    fDough: string;
    fSauce: string;
    fTopping: string;
    procedure Open;
  end;

  (*Builder - abstract class as interface for creating  objects -> product in this case*)
  TPizzaBuilder = class abstract
  protected
    pizza: TPizza;
    public
    function GetPizza: TPizza;
    procedure CreateNewPizzaProduct;
    procedure BuildDough; virtual; abstract;
    procedure BuildSauce; virtual; abstract;
    procedure BuildTopping; virtual; abstract;
  end;

  (*concrete builder - provides implementation for Builder *)
  (*an object able to construct other objects.*)
  THawaiianPizzaBuilder = class(TPizzaBuilder)
    public
      procedure BuildDough; override;
      procedure BuildSauce; override;
      procedure BuildTopping; override;
  end;

  (*concrete builder = provides implenentation for Builder*)
  (*an object able to construct other objects.*)
  TSpicyPizzaBuilder = class(TPizzaBuilder)
    public
      procedure BuildDough; override;
      procedure BuildSauce; override;
      procedure BuildTopping; override;
  end;

  (*Director - responsible for manging the correct sequence of object creation.*)
  (*Receives a Concrete Builder as a parameter and executes the necessary operations on it.*)
  TCook = class
  protected
    fPizzaBuilder: TPizzaBuilder;
    public
      procedure SetPizzaBuilder(pb: TPizzaBuilder);
      function GetPizza: TPizza;
      procedure ConstructPizza;
  end;

{ THawaiianPizzaBuilder }

procedure THawaiianPizzaBuilder.BuildDough;
begin
  pizza.fDough:= 'cross';
end;

procedure THawaiianPizzaBuilder.BuildSauce;
begin
  pizza.fSauce:= 'mild';
end;

procedure THawaiianPizzaBuilder.BuildTopping;
begin
  pizza.fTopping:= 'ham + pineapple';
end;

{ TSpicyPizzaBuilder }

procedure TSpicyPizzaBuilder.BuildDough;
begin
  pizza.fDough:= 'pan baked';
end;

procedure TSpicyPizzaBuilder.BuildSauce;
begin
  pizza.fSauce:= 'hot';
end;

procedure TSpicyPizzaBuilder.BuildTopping;
begin
  pizza.fTopping:= 'pepperoni + salami';
end;

{ TCook }

procedure TCook.ConstructPizza;
begin
  fPizzaBuilder.CreateNewPizzaProduct;
  fPizzaBuilder.BuildDough;
  fPizzaBuilder.BuildSauce;
  fPizzaBuilder.BuildTopping;
end;

function TCook.GetPizza: TPizza;
begin
  Result:= fPizzaBuilder.GetPizza;
end;

procedure TCook.SetPizzaBuilder(pb: TPizzaBuilder);
begin
   fPizzaBuilder:= pb;
end;

{ TPizzaBuilder }

procedure TPizzaBuilder.CreateNewPizzaProduct;
begin
  self.pizza:= TPizza.Create;
end;

function TPizzaBuilder.GetPizza: TPizza;
begin
   Result:= pizza;
end;

{ TPizza }

procedure TPizza.Open;
begin
  WriteLn('Pizza with: ' + fDough + ' dough, ' +
  fSauce +' souce and '+fTopping +' topping. Mmm.');
end;

var
  cook: TCook;
  hawaiian, spicy: TPizza;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    cook:= TCook.Create;
    cook.SetPizzaBuilder(THawaiianPizzaBuilder.Create);
    cook.ConstructPizza;

    WriteLn('(* create the product *)');

    hawaiian:= cook.GetPizza;
    hawaiian.Open;

    WriteLn(#13#10+'(* create another product *)');

    cook.SetPizzaBuilder(TSpicyPizzaBuilder.Create);
    cook.ConstructPizza;

    spicy:= cook.GetPizza;
    spicy.Open;

    WriteLn(#13#10+'Press any key to continue...');
    ReadLn;

    spicy.Free;
    hawaiian.Free;
    cook.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
