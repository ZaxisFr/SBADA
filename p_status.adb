with Ada.Strings, Ada.Strings.Fixed, Ada.Text_IO;
use  Ada.Strings, Ada.Strings.Fixed, Ada.Text_IO;

package body p_status is
  function getStatusMessage(msg: in string; statut: in integer) return string is
  -- {msg est le message à envoyer, statut le code représentant un statut}
  -- => {résultat=le message résultant de la concaténation du code et du message}
  begin
    return trim(Integer'image(statut), BOTH) & ':' & msg;
  end getStatusMessage;

  function getStatusNumber(msg: in string) return integer is
  -- {msg est le message concaténé reçu} => {résultat=le code de statut correspondant}
    i : integer := msg'first;
  begin
    while i <= msg'last and then msg(i) /= ':' loop
      i := i + 1;
    end loop;
    if i > msg'last then
      return ERROR_DECODING;
    else
      return Integer'value(msg(msg'first..i-1));
    end if;
  end getStatusNumber;

  function getMessage(msg: in string) return string is
  -- {msg est le message concaténé reçu} => {résultat=le message après le code de statut}
    i : integer := msg'first;
  begin
    while i <= msg'last and then msg(i) /= ':' loop
      i := i + 1;
    end loop;
    if i > msg'last then
      return "";
    else
      return msg(i+1..msg'last);
    end if;
  end getMessage;

  procedure decode(msg: in string; code: out integer; msgOut: out string; msgSize: out integer) is
  -- {msg est le message concaténé reçu} =>
  --   {code est le code de statut correspondant et msgOut le message reçu}
    i : integer := msg'first;
  begin
    msgOut := (others => ' ');

    while i <= msg'last and then msg(i) /= ':' loop
      i := i + 1;
    end loop;
    if i > msg'last then
      code := ERROR_DECODING;
      msgSize := 0;
    else
      code := Integer'value(msg(msg'first..i-1));
      msgOut(msgOut'first..msgOut'first+msg'last-i-1) := msg(i+1..msg'last);
      msgSize := msg'last-i;
    end if;
  end decode;
end p_status;
