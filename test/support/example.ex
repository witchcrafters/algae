import Algae

defmodule Example do
  @moduledoc false

  defdata Complex :: ([{:ok, integer()}] | number()) \\ 22

  defdata Any  :: any()
  defdata Int  :: integer()
  defdata None :: none()

  defmodule Embedded.One do
    @moduledoc false

    defdata do: quux :: any() \\ 22
  end

  defmodule Embedded.Many do
    @moduledoc false

    defdata do
      first  :: any()
      second :: integer() \\ 42
    end
  end

  defdata Bare do
    first  :: any()
    second :: non_neg_integer() \\ 22
    third  :: any()
  end

  defmodule Simple do
    @moduledoc false

    defdata any()
  end

  defmodule Sum.Lights do
    @moduledoc false

    defsum do
      defdata Red    :: any() \\ 22
      defdata Yellow :: any()
      defdata Green  :: none()
    end
  end

  defmodule Sum.Maybe do
    @moduledoc false

    defsum do
      defdata Just do
        value :: any()
      end

      defdata Nada :: none()
    end
  end

  defmodule Player do
    @moduledoc false

    # =============== #
    # Data Definition #
    # =============== #

    defdata do
      name       :: String.t()
      hit_points :: non_neg_integer()
      experience :: non_neg_integer()
    end

    # =================== #
    #    Rest of Module   #
    # (business as usual) #
    # =================== #

    @spec attack(t(), t()) :: {t(), t()}
    def attack(player = %{experience: xp}, target = %{hit_points: hp}) do
      {
        %{player | experience: xp + 50},
        %{target | hit_points: hp - 10}
      }
    end
  end

  defmodule Id do
    @moduledoc false

    defdata any()
  end

  defdata Wrapper :: any()

  defmodule Person do
    @moduledoc false

    defdata do
      name :: String.t()
      age  :: non_neg_integer()
    end
  end

  defmodule Animal do
    @moduledoc false

    defdata do
      name      :: String.t()
      leg_count :: non_neg_integer() \\ 4
    end
  end

  defdata Grocery do
    item :: {String.t(), integer(), boolean()} \\ {"Apple", 4, false}
  end

  defmodule Constant do
    @moduledoc false

    defdata fun()

    def new(value), do: %Constant{constant: fn _ -> value end}
  end

  defmodule Nothing do
    @moduledoc false

    defdata none()
  end

  defmodule Light do
    @moduledoc false

    # ============== #
    # Sum Definition #
    # ============== #

    defsum do
      defdata Red    :: none()
      defdata Yellow :: none()
      defdata Green  :: none()
    end

    # =================== #
    #    Rest of Module   #
    # (business as usual) #
    # =================== #

    def from_number(1), do: %Light.Red{}
    def from_number(2), do: %Light.Yellow{}
    def from_number(3), do: %Light.Green{}
  end

  defmodule Pet do
    @moduledoc false

    defsum do
      defdata Cat do
        name :: String.t()
        claw_sharpness :: String.t()
      end

      defdata Dog do
        name :: String.t()
        bark_loudness :: non_neg_integer()
      end
    end
  end

  defmodule Option do
    @moduledoc false

    defsum do
      defdata None :: none()
      defdata Some :: any()
    end
  end

  defdata Book  :: String.t() \\ "War and Peace"
  defdata Video :: String.t() \\ "2001: A Space Odyssey"

  defmodule Media do
    @moduledoc false

    defsum do
      defdata Paper :: Example.Book.t()  \\ Example.Book.new()
      defdata Film  :: Example.Video.t() \\ Example.Video.new("A Clockwork Orange")
    end
  end
end
