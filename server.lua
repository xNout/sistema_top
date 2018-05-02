local db = dbConnect("sqlite", "top.db");

function createDB( )
	db:exec("CREATE TABLE IF NOT EXISTS top_kills ( player_account STRING NOT NULL, player_name STRING NOT NULL, kills INT NOT NULL )");
end

createDB( );

function isPlayerInDB( player )
	
	local account     = player:getAccount();
	local accountName = account:getName();
	if( account:isGuest( ) ) then
		return nil;
	end

	local dbTable = dbPoll( db:query( "SELECT * FROM top_kills"), -1 )

	if ( #dbTable == 0 ) then
		return false;
	end

	for i,v in ipairs( dbTable ) do
		if ( accountName == v["player_account"]) then
			return true;
		end
	end
	return false;
end

function refreshPlayersTable( )
	local dbTable = dbPoll( db:query( "SELECT * FROM top_kills ORDER BY kills ASC LIMIT 20"), -1 )
	triggerClientEvent( root, "updateCTable", root, dbTable )
end

function registerPlayerDB( player )
	if( isPlayerInDB(player) ) then
		return false;
	end
	db:exec("INSERT INTO top_kills( player_account, player_name, kills ) VALUES( ?, ?, ? )", player:getAccount():getName(), player:getName(), 1 );
	return true;
end

function getAccountStats( account )
	local dbTable = dbPoll( db:query( "SELECT * FROM top_kills WHERE player_account=?", account), -1 )
	local rTable  = {}
	for i,v in ipairs( dbTable ) do
		rTable.account  = v["player_account"];
		rTable.nickName = v["player_name"];
		rTable.kills    = v["kills"];
	end
	return rTable;
end

function addPlayerKills( player, kills )
	if ( not registerPlayerDB( player ) ) then
		local accountName = player:getAccount():getName();
		local stats       = getAccountStats( accountName );
		db:exec("UPDATE top_kills SET kills=? WHERE player_account=?", stats.kills + kills, accountName );
	end
	refreshPlayersTable( );
end

function updateAccountNameDB( account, name )
	db:exec("UPDATE top_kills SET player_name=? WHERE player_account=?", name, account );
end

addEventHandler("onPlayerLogin", root, function (  )
	if ( not registerPlayerDB( source ) ) then
		updateAccountNameDB( source:getAccount():getName(), source:getName() );
	end
	refreshPlayersTable( );
end )

addEventHandler("onPlayerChangeNick", root,
	function ( _, new )
		updateAccountNameDB( source:getAccount():getName(), new );
		setTimer( refreshPlayersTable, 1000,1 );
	end
)

addEventHandler("onPlayerWasted", root, 
	function (totalAmmo, killer, killerWeapon, bodyPart, stealth)
	if( killer and isElement( killer ) ) then
		addPlayerKills( killer );
		refreshPlayersTable( );
	end
end
 )

addCommandHandler("mystats",function(source)
	outputChatBox( "* [TOP] Tus asesinatos son: "..getAccountStats( source:getAccount():getName() ).kills, source, 255, 255, 255, true );
end)

-- addCommandHandler("xdd",function(source)
-- 	addPlayerKills( source, 1 )
-- end)

setTimer( refreshPlayersTable, 1000, 1 )