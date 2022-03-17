defmodule NasaFuelCalculatorTest do
  use ExUnit.Case
  doctest NasaFuelCalculator

  test "correctly calculates Earth landing fuel for Apollo 11 CSM ignoring mass of fuel" do
    calculated_fuel =
      NasaFuelCalculator.fuel_for_single_event(:land, 28801, 9.807)
      |> Kernel.floor()
      |> max(0)

    assert calculated_fuel == 9278
  end

  test "correctly calculates Earth landing fuel for Apollo 11 CSM" do
    calculated_fuel =
      NasaFuelCalculator.total_fuel_for_single_itenary_item(28801, 0, :land, 9.807)

    assert calculated_fuel == 13447
  end

  test "correctly calculates Earth launching fuel for Apollo 11 CSM" do
    calculated_fuel =
      NasaFuelCalculator.total_fuel_for_single_itenary_item(28801, 0, :launch, 9.807)

    assert calculated_fuel == 19772
  end

  test "correctly calculates Apollo 11 Mission fuel" do
    calculated_fuel =
      NasaFuelCalculator.calculate_fuel_for_mission(28801, [
        {:launch, 9.807},
        {:land, 1.62},
        {:launch, 1.62},
        {:land, 9.807}
      ])

    assert calculated_fuel == 51898
  end

  test "correctly calculates Mission On Mars fuel" do
    calculated_fuel =
      NasaFuelCalculator.calculate_fuel_for_mission(14606, [
        {:launch, 9.807},
        {:land, 3.711},
        {:launch, 3.711},
        {:land, 9.807}
      ])

    assert calculated_fuel == 33388
  end

  test "correctly calculates Passenger ship fuel" do
    calculated_fuel =
      NasaFuelCalculator.calculate_fuel_for_mission(75432, [
        {:launch, 9.807},
        {:land, 1.62},
        {:launch, 1.62},
        {:land, 3.711},
        {:launch, 3.711},
        {:land, 9.807}
      ])

    assert calculated_fuel == 212161 
  end
end
