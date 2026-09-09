(function () {
    "use strict";

    var ACCOUNT_SUFFIX = "@game.sohu.com";

    function byId(id) {
        return document.getElementById(id);
    }

    function trim(value) {
        return value.replace(/^\s+|\s+$/g, "");
    }

    function setStatus(message, kind) {
        var status = byId("status");
        status.className = "status" + (kind ? " status-" + kind : "");
        status.innerHTML = message;
    }

    function validPassword(value) {
        return value.length >= 4 && value.length <= 16 &&
            value.indexOf(" ") < 0 && value.indexOf(",") < 0 &&
            value.indexOf("'") < 0 && value.indexOf("\"") < 0 &&
            value.indexOf("&") < 0;
    }

    function validEmail(value) {
        var at = value.indexOf("@");
        var lastAt = value.lastIndexOf("@");
        var dot = value.lastIndexOf(".");
        return value.length >= 5 && value.length <= 64 && at > 0 &&
            at === lastAt && dot > at + 1 && dot < value.length - 1 &&
            value.indexOf(" ") < 0 && value.indexOf("&") < 0;
    }

    function hasClientBridge() {
        try {
            return window.external &&
                typeof window.external.SetAccountRegErrorCode !== "undefined";
        } catch (ignore) {
            return false;
        }
    }

    function sendClientCommand(command) {
        window.location.href = "inner://" + command;
    }

    function finishSubmission() {
        sendClientCommand("enter_game");
    }

    window.submitRegistration = function () {
        var accountName = trim(byId("account").value).toLowerCase();
        var account = accountName + ACCOUNT_SUFFIX;
        var password = byId("password").value;
        var confirmPassword = byId("confirm-password").value;
        var superPassword = byId("super-password").value;
        var email = trim(byId("email").value);
        var accountPattern = /^[a-z0-9][a-z0-9_]{3,15}$/;

        if (!accountPattern.test(accountName)) {
            setStatus("账号前缀须为 4-16 位字母、数字或下划线", "error");
            byId("account").focus();
            return false;
        }
        if (!validPassword(password) || password === accountName ||
                password === account) {
            setStatus("密码格式不正确或与账号相同", "error");
            byId("password").focus();
            return false;
        }
        if (password !== confirmPassword) {
            setStatus("两次输入的密码不一致", "error");
            byId("confirm-password").focus();
            return false;
        }
        if (!validPassword(superPassword) || superPassword === password ||
                superPassword === accountName || superPassword === account) {
            setStatus("超级密码格式不正确或与账号密码相同", "error");
            byId("super-password").focus();
            return false;
        }
        if (!validEmail(email)) {
            setStatus("请输入正确的常用邮箱", "error");
            byId("email").focus();
            return false;
        }
        if (!byId("agreement").checked) {
            setStatus("请先阅读并同意用户协议", "error");
            return false;
        }
        if (!hasClientBridge()) {
            setStatus("请从游戏客户端打开账号注册", "error");
            return false;
        }

        byId("submit-button").disabled = true;
        setStatus("资料已提交，正在连接服务器...", "success");
        try {
            window.external.SetAccountRegErrorCode("0");
        } catch (ignore) {
        }

        sendClientCommand("submit_reg&" + encodeURIComponent(account) + "&" +
            encodeURIComponent(password) + "&" +
            encodeURIComponent(superPassword) + "&" +
            encodeURIComponent(email));
        window.setTimeout(finishSubmission, 120);
        return false;
    };
}());
