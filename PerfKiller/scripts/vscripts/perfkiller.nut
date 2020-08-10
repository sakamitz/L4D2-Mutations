IncludeScript("VSLib");

DirectorOptions <-
{
    weaponsToRemove =
    {
        weapon_pumpshotgun = 0
        weapon_autoshotgun = 0
        weapon_shotgun_chrome = 0
        weapon_shotgun_spas = 0
        weapon_grenade_launcher = 0
        weapon_pistol = 0
        weapon_pistol_magnum = 0
        weapon_melee = 0
        weapon_chainsaw = 0
    }

    function AllowWeaponSpawn(classname)
    {
        if (classname in weaponsToRemove)
        {
            return false;
        }
        return true;
    }

    DefaultItems =
    [
        "rifle_ak47"
        ""
        ""
        "first_aid_kit"
        "adrenaline"
    ]

    function GetDefaultItem(idx)
    {
        if (idx<DefaultItems.len())
        {
            return DefaultItems[idx];
        }
        return 0;
    }
}

function Notifications::OnTankSpawned::ResetHealth(tank, a)
{
    tank.SetHealth(300);
}

function Notifications::OnWeaponReload::SpawnTank(player, a, b)
{
    if (false == player.IsNearStartingArea())
    {
        Utils.SpawnZombieNearPlayer(player, Z_TANK, 1200, 400, false);
    }
}

function Notifications::OnAmmoPickup::SpawnTank(player, a)
{
    if (false == player.IsNearStartingArea())
    {
        Utils.SpawnZombieNearPlayer(player, Z_TANK, 1200, 400, false);
    }
}
