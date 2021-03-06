<?php
if (!defined('IN_ANKIXMIS_API')) {
    exit('Access Denied');
}
/**
 * 字典
 **/
////////////////////////////////////
// action的用户组列表（空表示全部用户组）
$actionlist = array(
    'getOptions' => array(),     //!< 获取筛选项列表
);
////////////////////////////////////
$uid = $_G['uid'];
$username = $_G['username'];
$groupid = $_G["groupid"];
$action = isset($_GET['action']) ? $_GET['action'] : "get";

try {
    if (!isset($actionlist[$action])) {
        throw new Exception('unknow action');
    }
    $groups = $actionlist[$action];
    if (!empty($groups) && !in_array($groupid, $groups)) {
        throw new Exception('illegal request');
    }
    $fun = $action."Action";
    $res = $fun();
    ankixmis_env::result(array("data"=>$res));
} catch (Exception $e) {
    ankixmis_env::result(array('retcode'=>100010,'retmsg'=>$e->getMessage()));
}


/**
 * 获取筛选项列表
 *    返回数据格式: [{text:'男',value:0},{text:'女',value:1}]
 **/
function getOptionsAction()
{
    $res = array();
    $key = ankixmis_validate::getNCParameter('key','key','string',1024);
    switch ($key) {
        //case 'city': return C::t('#ankixmis#ankixmis_city')->getOptions();
        default: break;
    }   
    return $res;
}

// vim600: sw=4 ts=4 fdm=marker syn=php
?>
