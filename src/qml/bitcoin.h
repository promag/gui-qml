// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_QML_BITCOIN_H
#define BITCOIN_QML_BITCOIN_H

#include <QGuiApplication>
#include <assert.h>
#include <memory>

#include <interfaces/node.h>

class BitcoinGUI;
class ClientModel;
class NetworkStyle;
class OptionsModel;
class PaymentServer;
class PlatformStyle;
// class SplashScreen;
class WalletController;
class WalletModel;

QT_FORWARD_DECLARE_CLASS(QQmlApplicationEngine)

/** Main QML Bitcoin application object */
class QmlBitcoinApplication: public QGuiApplication
{
    Q_OBJECT
    Q_PROPERTY(ClientModel* client READ clientModel NOTIFY clientModelChanged)
public:
    explicit QmlBitcoinApplication();
    ~QmlBitcoinApplication();

    ClientModel* clientModel() const { return m_client_model; }
#ifdef ENABLE_WALLET
    /// Create payment server
    void createPaymentServer();
#endif
    /// parameter interaction/setup based on rules
    void parameterSetup();
    /// Create options model
    void createOptionsModel(bool resetSettings);
    /// Initialize prune setting
    void InitPruneSetting(int64_t prune_MiB);
    /// Create main window
    void createWindow();
    /// Create splash screen
    // void createSplashScreen(const NetworkStyle *networkStyle);
    /// Basic initialization, before starting initialization/shutdown thread. Return true on success.
    bool baseInitialize();

    /// Request core initialization
    void requestInitialize();
    /// Request core shutdown
    void requestShutdown();

    /// Get process return value
    int getReturnValue() const { return returnValue; }

    /// Get window identifier of QMainWindow (BitcoinGUI)
    WId getMainWinId() const;

    /// Setup platform style
    void setupPlatformStyle();

    interfaces::Node& node() const { assert(m_node); return *m_node; }
    void setNode(interfaces::Node& node);

public Q_SLOTS:
    void initializeResult(bool success, interfaces::BlockAndHeaderTipInfo tip_info);
    void shutdownResult();
    /// Handle runaway exceptions. Shows a message box with the problem and quits the program.
    void handleRunawayException(const QString &message);

    /**
     * A helper function that shows a message box
     * with details about a non-fatal exception.
     */
    void handleNonFatalException(const QString& message);

Q_SIGNALS:
    void requestedInitialize();
    void requestedShutdown();
    void splashFinished();
    void clientModelChanged(ClientModel* client_model);
    // void windowShown(BitcoinGUI* window);

public:
    QThread *coreThread;
    OptionsModel *optionsModel;
    ClientModel* m_client_model{nullptr};
    //BitcoinGUI *window;
    //QTimer *pollShutdownTimer;
#ifdef ENABLE_WALLET
    PaymentServer* paymentServer{nullptr};
    WalletController* m_wallet_controller{nullptr};
#endif
    int returnValue;
    const PlatformStyle *platformStyle;
    // std::unique_ptr<QWidget> shutdownWindow;
    // SplashScreen* m_splash = nullptr;
    interfaces::Node* m_node = nullptr;

    std::unique_ptr<QQmlApplicationEngine> m_engine;

    void startThread();
};

int QmlGuiMain(int argc, char* argv[]);

#endif // BITCOIN_QML_BITCOIN_H
