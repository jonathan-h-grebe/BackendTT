defmodule NasaFuelCalculator do
  @moduledoc """
  Provides the function calculate_fuel_for_mission/2,
  which calculates the amount of fuel required for NASA mission.
  
  Missions are considered as lists of "itenary items".

  An "itenary items" is considered to be a tuple of the following form:
    {atom specifying "event" type, gravity in units of metres per second squared.}

  The type of an"event" can either be a :launch, or :land.
  """

  @accu_fuel_init_val 0
  @type event_type :: :launch | :land

  @spec calculate_fuel_for_mission(non_neg_integer(), list({event_type(), float()})) ::
          non_neg_integer()
  def calculate_fuel_for_mission(ship_mass_kg, itenary) do
    # All fuel must be taken from the outset of the mission,
    # so here we work backwards from the final itenary item, such that the mass of the required fuel
    # from the latter items can be taken into account in the preceeding ones.
    Enum.reverse(itenary)
    |> Enum.reduce(@accu_fuel_init_val, fn {event_type, gravity_ms2}, accumulated_fuel_kg ->
      total_fuel_for_single_itenary_item(
        ship_mass_kg + accumulated_fuel_kg,
        @accu_fuel_init_val,
        event_type,
        gravity_ms2
      )
      |> Kernel.+(accumulated_fuel_kg)
    end)
  end

  @spec total_fuel_for_single_itenary_item(
          non_neg_integer(),
          non_neg_integer(),
          :launch | :land,
          float()
        ) :: non_neg_integer()
  def total_fuel_for_single_itenary_item(
        @accu_fuel_init_val,
        accu_fuel_kg,
        _launch_or_land,
        _gravity
      ),
      do: accu_fuel_kg

  def total_fuel_for_single_itenary_item(mass_kg, accu_fuel, launch_or_land, gravity_ms2) do
    fuel_for_event_kg =
      fuel_for_single_event(launch_or_land, mass_kg, gravity_ms2)
      |> Kernel.floor()
      |> max(0)

    total_fuel_for_single_itenary_item(
      fuel_for_event_kg,
      accu_fuel + fuel_for_event_kg,
      launch_or_land,
      gravity_ms2
    )
  end

  @spec fuel_for_single_event(:launch | :land, non_neg_integer(), float()) ::
          float()
  def fuel_for_single_event(:launch, mass_kg, gravity_ms2) do
    mass_kg * gravity_ms2 * 0.042 - 33
  end

  def fuel_for_single_event(:land, mass_kg, gravity_ms2) do
    mass_kg * gravity_ms2 * 0.033 - 42
  end
end
